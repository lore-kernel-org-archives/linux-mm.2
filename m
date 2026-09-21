Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5F6C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE69A6B00B9; Mon, 21 Sep 2026 14:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E980B6B00BF; Mon, 21 Sep 2026 14:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88FD6B00C1; Mon, 21 Sep 2026 14:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD5C26B00B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:39:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37D01120262
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:39:34 +0000 (UTC)
X-FDA: 85238632668.25.F276FEF
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67C35C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:39:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MSyNQU3L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790015972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfp1Yz3ifDR2lWMmmnGcVuQR5yKwqsCt+IibNOfjTJk=;
	b=299KtSiOYKmL0mqDqBM8JFD5Gb7+xF5YWNbM0To25JAZmHdPXh6GCTZKkkHqOxdC546mnx
	RGs6TvypYuf0AnIAZCvT5acgeQ5j/1KW0dzcW91cXG2YrR0bPMVrecOGG830EjRx/RIkUC
	VKh7ajpvgzMeYT+miIWvJNoDUqfTxkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790015972;
	b=QiNFY+VEka8wx1DoiTVrYoNgjmcgioLXpSdAXL+bY2Ioy6EeMhj5/+mn8iiHHnz7f9IPye
	7aRfEqk4/Qf0ZAm7cZKyydcGo7WBoSgb8+k+ma5ifZZ+my91zGwssqspa9ILHxhnhyVhYZ
	WUkBBJzQ1Wqx1KbCch7yRoDwxTklJJo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MSyNQU3L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so24867095e9.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790015971; x=1790620771; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qfp1Yz3ifDR2lWMmmnGcVuQR5yKwqsCt+IibNOfjTJk=;
        b=MSyNQU3Lji2yy2twf/r/FYWdkHdqlgPH47yv9lh2GPAPkIWgo2KXBOwboh4nYw9cYs
         CWkyDN9yWxmKROGN9B9tHDnFjJxP8fgb4MZtVvWKRRfu4tNeWIWOYP0sxhu8IdkQQ4fE
         iZgiPa6imRrFVm/T4Q4rsihQHlF2lEAEtBsoW4Nj3UAqeMIbhLp5MT7ltZCA2vBOXLdL
         Lu2tt3GBdz2ljIWZP+ClhBW+fNQhzUtRXPzO6cSTE2MxlVIsLPRXUALHipfWrFlNdVRD
         gy/c6gE/GJNj5aNF6sPBRYJE6uHEjJRjTJ5r1P8z5ETUJ1B51xvducp8lmmdXuHUvdTI
         WSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790015971; x=1790620771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qfp1Yz3ifDR2lWMmmnGcVuQR5yKwqsCt+IibNOfjTJk=;
        b=EGRySCIaLcs4iBg/lP16vUBluuW9JQ3UqktVdxmKdEoofVS5uKgQSTq3vIl35CZgOb
         /Yjh/KTww5xfrR7GHOWwdmhrwbwvlAO1WisRR/DOI1JvNXWb9u1LAatuBmKuBEoV/mpq
         bQt3byAoEMW37k0g0D05894dYaXfsfDAyauvtXfV6WZOBSJgZp1zhUrK5WXafHZhHx1N
         nTTIiV8LJtftnIFh3uCu9siuL3c+tzBxVuEEVrC/L8ccCnpYAoVqvVHdMZKkFKZYHDP8
         9Ss4FlcRKRX+b3bD+WLPdwxCyAbjTGeTEX48QwwOqWEEFEQqN9X09DirVL/0KRockTAx
         HZQg==
X-Forwarded-Encrypted: i=1; AKwUvBztc6qS4mSMKF7aZNDjdwi5JH/9gy/9NJJ+yesngL8WLaiahFubhxp/sEKA6gX70kjciEuWfjDu8Q==@kvack.org
X-Gm-Message-State: AFuF++nmCEAMvB7hJYu0GWDidZWNhuYTT55HmfDyknKKOWuJ+DOBR1K2
	kDTs9lHDl3GJrV5xyhM3vxmuJ54s0u9/SMYBi6Om7k3U+T6ESJ9uQvZBzhTxCA==
X-Gm-Gg: AYBFou3Bnu7OTHceZT9ffjVzhDiG6A2+Iuf9YNPKXQ6822LQflJULhvXBkJWG4BQZ/a
	mt0zvXuhaXO1DxFpJoCqwVP+K8faZmL2Vlv4XrsFxbVXT5hZE4Lg3L5bVTw5yxSQVvLvr7ajSBa
	POhMmVV3t5EtD/yxlbtIS+Q2aH44HnmTjPiSElYryH00oK6Yh1r2qPEfdeClzjhO8vjirKISdFC
	lCPBNi9JW81Y6Db7b/4emaohnL6bjeb/9UP5pvOEdjUmaBxxWRPPvlsq2KYUB2VaugUC9nuofmP
	bZpd73nD66c6l4Uj3O/YAY4j54ULsFIYcd52criHSFJkWxQSHVrvlKsLEWOUWalOV58n2Bg9dEy
	ovGkobbVZJUt3/IIflVNlhiExsenRD3mnaBK402CWU8mV8L5p0FB9oe3rfYRBCGk0SI454f98Al
	Km76VB2bEH84htOwtGdLzPR6FpoxBwTPA9d/EtdCSVO7oRXZp3cF4jmdMwPa9RrqBRLRcAOtVki
	6Ew49+wYkpVqEn75KUGevS0c65y9htFyuAwX8NNHcxG7HfYlBIFKoyUbRq6xT2k4q97IB4ez0IS
	b6ZhqYnFExReGXUJp9gWDsRReKFX7ETn4rj9v4KjCazUmmm7/1ffxUy2o7/JGzr1GWbCmyzaVie
	NdXblz3VxpyGF4fRl
X-Received: by 2002:a05:600c:6214:b0:49b:9202:6f80 with SMTP id 5b1f17b1804b1-49fc568129emr158209655e9.6.1790015970588;
        Mon, 21 Sep 2026 11:39:30 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a8e9-c501-45ee-6f60-3fc5-4072.310.pool.telefonica.de. [2a02:3100:a8e9:c501:45ee:6f60:3fc5:4072])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8ccd185sm10667745e9.8.2026.09.21.11.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:39:30 -0700 (PDT)
Date: Mon, 21 Sep 2026 20:39:27 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon: preserve temporal quota state for
 unmeasured PSI goals
Message-ID: <arF2epnyKAdkwSG-@gmail.com>
References: <20260921020013.33105-1-kmehltretter@gmail.com>
 <20260921164749.82070-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921164749.82070-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 67C35C0003
X-Stat-Signature: wfidokau6ayookc396hq15rwqf6zf7fj
X-HE-Tag: 1790015972-645674
X-HE-Meta: U2FsdGVkX1/hVM0SHYTh/zQKRnPXcLrBEzjeybXVwTHcwJtCMKnC90KW1FTvwpfGzRsNZdC8wW40VHGwHc6ogDK0biNfodaNZ/Ft4gnWbrGNw1kEhLtgNRbLWGzzKUgDWFWJtxzDKQbD/4nWmp5EAlEmOMsl27wVVtGX2Kv/fxcRXCzXE5iHEr3jtRZb4pOhGRslrtOs+UxOzT1qVLKb2QfktVoA3RARskJH6i/kkh7aPDjKKSD1Nolat8FWBa6YO8oXqxGB9ovfzO9BgSBg+sKQUIP4Qf/NvQGajkMf4ZZl6JlOz2Dy4fMbGup/TWydE0zJwV/UaOGwsflkSq6//qeDRVrdYjwwWrzcq02qmmkJQl8mQu/SSl9Yz6SsQO+uBg0dHGIRmOMnR/JcQ8ZI3apjcQad6tcxuNpleq57R/k4J52jI9qwn/T8qserrXSLqat4y8dCR6yEfr4x6Es03xY0+rkstH81PEpUxG7SXomVtWug2Gv0xVdsdS4IMos1ZdZeQ6ly2HjLTu6zHpbP3BqP5VKWG1KIHr4B0w8SUPQPrUh1DYuX0V3R5HMEup/g+LhMJBl/Fx7ooBChVHuWQK53UadNFk4NfCSUj054UTntMi3cwwvC3AcztdVMa9Ue07RlURoKcgANQpc3J9iwoE5l1TvoRmdFQQFey+jkOncCNZiyB5xlHe6EGD03eeEYVWyI85Mpw97VB7sQ+4C+QOo9V3seUcx515Lej18eeWZH7TF+Mak8FxEA931ymlqrR3A/rv6d50rCeUdMa0jT4kyAz3LrjaGgQbl1qzz2t/H+sVCVua/ufjnd1eyvy9DFMhbk31k7Jj5i6ZG4FM0MEiUzmSACssTGAnPtUrgAumbvD/CQN9EcfRIVTFQAnYjmbH7jjJib8ql8jVXe7eEs1ueXiDvOCgObRT4Dj4Yd7FqMp6alpd6tYBcpEKSrf8U83ZaBWYTnYygHAIDYf8N
 EnI+rGL8
 qkKpKlxdyQXwkjfXvFIUOYovbofu4Hfd/RofWbiajwyZvFmEWKDjWrH8m+Ye1qcOlkye+ZHbQZ7pZaTupzF/1FQWiiBY85wzDPdUQzxQHMBRXExQUStFjS45XRz7ucIDqOj899/qJmoR6lJrosulGCjrg6kVeua5p/FAty14UJTSMEPMBnJ8dpv0SOQkGNKb+c8hPqWkJyjH3jau2BdoO9MuwzlP5TB4ogsP4ENBuqxryTVAEVqO/UH+UHUf6qGEZiV4UTgx3OBPPD81OtPjwgjbT+jefi8QVZDRlntv47yArN7g+12UgiKadEobjCTyJRpxpcoddRiSL7ym1Bgncp9uOzDEmgxi77j7/v+l41hHNM2vDwDDxjmHPGZkbjstA9YIsjA1CzmC0WYRK869WLjndjDKE2RiOZRekKpzN043+dGklokqSnvMkSMAJP4yB0BLRYH0gZmHbopxjVecjeor5k9ATihWphS//nZxcAWn7VLw0mde9jHDaAHYJhEEWdhozDRFW8YXQXJE37GIpbMPTu+8EfrCJaHUSZlmoK/CjKywaKUdR3Y9A09JpC+0ST2jnnx7PYHgAj/le6dH0MQ4172/HRJZnVF+qxie81NucJc8PhKF5Y4y/9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:47:48AM +0100, SJ Park wrote:
> The patch 1 has wrong Fixes: tag, as I replied to it with two options to path
> forward.  Speculatively assuming your preferrence is option 2 (adding this
> series with fixed 'Fixes:' tag), I applied this series to damon/next [1] tree
> with the suggested Fixes: tag modification.  Let me know if you want the
> options 1 (squash it into the incomplete fix [2] before it is merged into the
> mainline).
> 
> Unless you want option 1, and if this series is not added to mm.git in short
> term (~1 week?) with option 1 update, I will ask mm.git maintainer (Andrew
> Morton) to pick this.  So, no action from your side is needed for now unless
> you want option 1.  If it seems I forgot doing that or you cannot wait for my
> action, please feel free to ping me or Andrew.
> 

Hello SJ,

Thanks for reviewing both patches!

I used b73198a47ffe in Fixes because that commit introduced the problem
with the temporal tuner.

I thought a Fixes tag could also point to a commit that is still in a
maintainer tree. The tip handbook describes that for tip [1], though mm
may handle it differently.

The hash can still change in mm-unstable, so the tag may need updating.

I also found this reply from Andrew [2]. He says he tracks these fixes
by filename and folds them into the original patch before moving it to
non-rebasing git.

Maybe squashing is indeed simpler here, also for backports.

So either option is fine with me. I'll leave that to you and Andrew.

[1] https://docs.kernel.org/process/maintainer-tip.html#ordering-of-commit-tags
[2] https://lore.kernel.org/r/20260313091738.354244f6fb500bef3bad1fa1@linux-foundation.org/

Thanks,
Karl

