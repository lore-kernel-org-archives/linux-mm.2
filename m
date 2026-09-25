Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A80C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548B66B008A; Fri, 25 Sep 2026 02:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F90E6B008C; Fri, 25 Sep 2026 02:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E996B0095; Fri, 25 Sep 2026 02:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1594B6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:55:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AF24C055C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:55:47 +0000 (UTC)
X-FDA: 85251374334.11.FF7E452
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5499C000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:55:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXWeDjqc;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
	b=p15ESqLyyAMwB6larsCI8PtFO92xHYWAOC1MtTUsLA6rrZ/LkFHSKOx0xX0ener+M0l82W
	R7QWPuMo228M8SRZmeG1qW2F30TACQq99cW61GsQ9i2sq+dXYTjG9AmqxugVi+K/iJkXXM
	sIZa915jVpsrxyd7KtcdGrRsNVH3Nfo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXWeDjqc;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319345;
	b=qY+2AkMGT4mRTTVa57Q/cbQRVvgDQdNXtNgur/0uj+Es5O6W3xg7TxIqh2KesMfbrOSnKr
	6O2Ri1oNWxDiOuMsXn34m0/tCvpUAsa82Uwmov6mfdb6y4sjWjlGQeROMpqC902IWY5Fgz
	SFxu3xWj75gAnmiPv4+xToI+qjTON3U=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4d04d740cso186904a12.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790319345; x=1790924145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
        b=HXWeDjqcAS1Te9Srj57qGtwQCDlxf/ieFSY3n3O18YPJENDmNLHZqN8Z8g9Z8Wjm/Z
         k3GUmbLBo0qnZ5e7/Aa7fDvBXQ8pPHvPoE8cFSZ8lgy6wr/teEazcYFiy0Qk6+8Jo1L8
         SzXwH9tfLpiNc1dMNviblTSIBttghSTeWmjnPCTlWMKJEvwWz5F9W7nEOybeA9mZK18P
         CKTKzQFrnSqbxREuoCxxliK0kCMx7fasvPXYbt0UhUQ8jceFsRIFdYJ+KJOFVQo5EHaT
         DKsO25+ISaqLCY6Qly/gzIxv/4h8URcioGIyuLhw4N+Bice5y3bDWXpgG2IK5cmEfxS4
         mimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790319345; x=1790924145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tx5lnhA+lxgkmkf1DN+MC9Y5ctB2DhEwgjJwGzsdzag=;
        b=RNm1vUzZKDes3RGRDJj8ugVm/DuJo3ZE4jyePYjG3/JlzcdZaCS72G5SxrL9ZIdYhb
         RvNzMMxsqve8seRLhvhzBziHyCjeysx6yi3WV0OczxNkzBNeg01rkmhjgg5y4qnIk2JA
         mau+iUCI6EVuZqg6uHbodXMFoQjkBs3A20tIdvAIWiOW+eC07RK3YdP1WrSYSDUvuGof
         PqlLtakkROFyjuMcSMOrUJbNLbEBujPgZeOFPF0RGdlAVmcQvJsDM7grkuJ66Yflfp5J
         JNxRHt1mX2dfyGjoW9zbpv8XKYI35SriqJsaGVt4203MntBBaKuqOIjkn6FZw1iiCGuV
         bGqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHMdIMzbKzgHzs08YGfOz/HvSmlqVNMyyI7WRRdhlXKYb8mM/ZOdi8MTeF+n/r96wgBXoFsxap6A==@kvack.org
X-Gm-Message-State: AFuF++krJmgqktSP+/ee8Sf1R5K59uQJD7RS9D6Km/zqjzX9P6ME9w3i
	eg6KLAIXGilNxIkvy0enMN6Hiaf2bZ0vZY+mYWRDzxCj0ep31gMWpPbs
X-Gm-Gg: AYBFou15dO3KS6KYPur+Jaq4KTJZv11KaoLQOwHjStrbcWB1KMDjUEpBrrVNW7XFVy6
	/SWvd1L7e2NesX5PKHevWs/W+v1qmRisHYhSUWMk69ZlCWIR64y0/8NdZioU4PT39aRQDR7FiKg
	N1w3IXWNV9jfQoTn6RENdNbZjJFRAeo4r2Zv2WT1rg0CwvYo6VLvUZfyPLr/FN3PsxHInioQJWJ
	3wcyLSQpdY1vyvNiePMXRs5jy3EQ4tEzcW4ZJFNix/MSydkS1KUmfJGIM4LToPxOmdtsjDE3YKW
	4WE7IJFDFoJ+SdJ0qG4RJS9un4JBVy4jgRfNkylOsTn6iGNgzGXnOdxFKApP/wzlcGWbdNgrLPw
	TtePhJ45wc9NH6Bhp4ad3CWXK88RnU1lnSDF63kVQO5UontDSxZKNDhS0RwnDwVfOhupBufxXdo
	IqwX5V9gCxqWDvexSCbv7E4JWum3+pIDp5rlH0u8+xqxL+puwjR7OlHk9naNQtwe1fY8NRfAXBY
	m+p/YGiyF44UO65P243soxHCvA9bzgJRvcNhxET
X-Received: by 2002:a17:90b:3985:b0:39e:6c69:f482 with SMTP id 98e67ed59e1d1-3a098d5e61fmr4310895a91.65.1790319344531;
        Thu, 24 Sep 2026 23:55:44 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998e2bdsm2718096a91.13.2026.09.24.23.55.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 23:55:43 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	taejoon.song@lge.com,
	lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup selection
Date: Fri, 25 Sep 2026 14:54:57 +0800
Message-ID: <20260925065521.36340-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQJIjzE0BlUg0CV@cmpxchg.org>
References: <20260916183437.2946306-1-youngjun.park@lge.com> <20260916200434.GA5784@cmpxchg.org> <arAHu_BD5oqpZJER@gmail.com> <arQJIjzE0BlUg0CV@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5499C000D
X-Stat-Signature: qajphud4epuqm7ehdgzhw9qaxo7fm7a9
X-Rspam-User: 
X-HE-Tag: 1790319345-437364
X-HE-Meta: U2FsdGVkX1/HYl8WOwtyi65HyOEN6jxlfFoJ9BCgE8BC/q++xOFc8My0LmyPETcMtOwlpoRKuKAJwQ8WUvZKli3ySfAo9FyaECIPX42AehQ8dj+OprQqtI3QHm89qYrhMaJmhIfWtA1gA42B9edMXfl/uoMzUf8QNKPTrRZ9w/fA/4z1rM1j05kjC6z1ATJI2QnbIdpyDyPRDhLBGkalK67Z1xlxx0MRpw2XB9BW7Fvd9SWzLk8DpyQrH2PnVy4nVTlY2+m80SOsAm1cF7oMpuWEDLQcN0BcXIHXU7ZT6ScZjXR/pQhO3LS00mf519C5cDVpGxOuemJlVhBNhjm1b5h/KrzI1ks6lsytDNE2iaYIrVtc8BWavWxl+hcqwfoLFSwRfMC+/H2dOB9jcdLm9ufhwTBLilxMFrZAygh1+eZVxcWp9Z1HMUZM4sBz9w3tHr+PTp46cuzLdHCPduaMRQx11OO3JMSzRw9F0+R9jgJUE7yNAV94dQuhRmTGuem9e7Ln9o8HZ0kcC8bRR/BJIMOPr9o99/kGuukt7k0FvCGiB5FKU5N64kHM3TppieCW2iTz9CtliM2dDlq7gdQofCysiCGk0CPxPXI6CUBxE9SMod7mRGCyfg1XvzrMBKSNGBxrP0PcJF4Cv13nER/caDDyH9HCzTfFBTTAUSWyOYU6rHlsupAzJxzY7KU35h615piGmzmWbIx9rsjBY7NtS1/caovLasnyNjWSs0SMKXnUapstc4ovXOmTQOBvPthRjKu/KDfsmGLeECuim440y8PmjD9bo/aBxPM2AfjaRssyz3UZPzXd5RFXRVwi66+I78E7hO5prFgSSyopLa1CRKSBVlMR7dvC86beJ3x7zRoAFZADt/3ge9s4LIThar6QDOhUrn4Ycxw4TFmZHjBqU34e9vXC5uRLYPfG0cSqZJwUi67Ww9vzdDy9AMNqPwckQXLFLJ0lbJQC5a9WXK6
 j3ZqLPRP
 bhOJnNlvcGD4azD0QojSRM41G43RUgQswzdEWjNtevuA4QnsnjzJkeyKOE4CZEZnnTyLvwJu5Zc8EjSHIvFGgxUZ71BbM4hXZ0ZWv4JdWN9k7IoM/H0gEXYYiCraBZjifQ6gOnu/XmQCY6RbW6aXxzVUa8iRHhkMxGKxZr6Dmh3TeXWWH3Hd+VpwU6kA7KfdgAcmC2By3gsX22SbwUUjM4xCc5qI/G2+J3lSpXzBnBnAfmnSiHLPbbPBjYtLjdmr17mIAKHYJK6A1axX75ZobCLIMQR0PTG0kfW0+di1Aw7A+1nzJMacr9EF9GlhfnwDOGfcVO/9xs+pdXoS8Nc8IctwtGjnY8Rxgqlu32WCVLg1c/bE8dWiPqDlEheQUdJfjpnEsePgSpKuPyTACg6HFXngB1OGJkAgmEuUhiC93JST6BYcCneHLLplNvvElHNrHkT1QUmPFLORFZgszcLfE2UIxDzXmNkIHJYs2oTgc3QtkW9mvzZnes8z10bu8gHeK1/Zc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 01:15:14PM -0400, Johannes Weiner wrote:
> If you can think of a good usecase, memory.swap.prio.min would be
> certainly a natural extension. But we should get the usecase laid out.
>
> The requirement to punch holes is the one I can relate to least. Why
> would a cgroup need access to good tiers and bad tiers, but skip the
> middle ones?
>
> This would seem less like tiering/hierarchy and more like flat
> per-cgroup swap pools but with obstacles.

Hi Johannes and Youngjun,

Sorry that I am only joining this part of the discussion now.

I recently started helping carry Kairui's swap queue work forward. Our
current v2 is here [1]. Youngjun's tier work interacts directly with it:
v2 maintains a device queue and reader for each priority, while v11 makes
each priority a tier and moves device selection under that tier.

I did a functional integration test of v11 on an x86-64 host. The tier
mask, fallback, same-priority device allocation, concurrent allocation,
and swapoff smoke tests all worked without kernel warnings. This was a
zram integration test, not yet a real multi-SSD performance test.

One result seems relevant to this discussion: with a restricted parent
and an unconfigured child, the child could still use the faster tier. I
therefore agree that an inheritable memory.swap.prio.max looks like the
cleaner first cgroup interface. A hole in the mask worked mechanically,
but I do not yet have a convincing hierarchical use case for it; it felt
more like per-cgroup swap-pool membership.

For the queue integration, one possible boundary is for the tier to own
the queue/reader and for the swap queue to become the default per-tier
device allocation policy. I would like to align this with both of you
before changing v2. I will also continue the real multi-SSD tests.

If either of you has suggestions or specific test cases you would like
to see, please let me know. I have a few test setups available and should
be able to try some of them. I am still getting up to speed on this part
of MM, so please correct me if I missed some context or got any detail
wrong.

[1] https://lore.kernel.org/all/20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com/

Thanks,
Lian

