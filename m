Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5686F10F9307
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9296B0092; Tue, 31 Mar 2026 18:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E96B0095; Tue, 31 Mar 2026 18:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6D36B0096; Tue, 31 Mar 2026 18:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3E36B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:39:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9C21B8977
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:39:08 +0000 (UTC)
X-FDA: 84607825176.21.FDCACD4
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id E82D420008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:39:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HPLHAuHM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774996747; a=rsa-sha256;
	cv=pass;
	b=XIDEqEZdXTvasicTRrSJ/wCJC/EVbFoZj8j3fkZ8XwaHWBhJBvlcOy2UfF/P9lCbmG/0iJ
	ssPjuhKuUDD0WMyl5XPEI+HbidTer7TU3MIZm17QUTcyPyNYmLSF37he6hR6zDuT7Ii0tX
	I2wLz9yzsWMKZ+xQcgaiFOteAdzzuKE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HPLHAuHM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774996747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOm+IZBI9Gyyl23ujT1K624bUaJ4CxbCURFBAGSrpjs=;
	b=GbQUGRvy3jq2tfq2qlT5rsdwhXFfg+lNH3NASEJEv8DSB1W5g31yQ9qf65PwWoZ4JTWcgs
	GSA1FCVaOlnYC7/bRgnqG2r0QOvbYzRDOlJn/CZjU7ALy5T8k0PhwyqzD7JIQ5MyXn8c6y
	BsHEb4OAJ8VQI0nYck0D50awed3KjDQ=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2c1632faeb9so11260925eec.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:39:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774996745; cv=none;
        d=google.com; s=arc-20240605;
        b=BZEqDE0jL1JJMBLfNqL7DtXqXvaKmOL3GYYLhmfqNksD7StFyBZQ6oCN/vTAe9sxI8
         kzdbGckNxxNEQkkjAmNovfDjGHQ4OEwvzKvfOq2r9+fPkc6nxDhlAG3yaolP9mhxzbSv
         l7UnEgLImNIjssLId0gtxSypDCiA7fXY/Quc05hJ4Cm0w9IyAY2MK3W6RF6SFETx9QVx
         4WGyfCZc7NpSTFhFll3Jqi4nJOIHrecleRvO6Go2F2lSank+f+Mn1Mqp/6ZtXN0fjb4r
         Q9aLjeiamveNsfxkqVMbmCDKR9VWdicpXBiQuMM+Nzib6HMGifsHj3s8MECbv8YnIjzD
         IdKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nOm+IZBI9Gyyl23ujT1K624bUaJ4CxbCURFBAGSrpjs=;
        fh=ixaSOmd1jDXy5lxZwkHvotBQNP3FtIzJ/7JKZuBL+uw=;
        b=Sxs3Ez7qyuWkRO2iPevhQ/JRxwMnklnYclYPOk2E9ykHiQF+QbmOnCdvV8SIv4YpQV
         pBgX0x/Ruw3Br2r4fdBLO/MTb6gWpDpfKWZ7LcrblxC+omhC1drBuql+4QZs7id5+r8Z
         mBZ1BXFjAYq0Y2FyQEt8KZKb58DZd2vtSNpkPFlmjpbZ/vjyXRHW0YE24KlloBffXQye
         KNpLdQby9bMA0Z7XZzL9kOJVvr3tVETVVHIfEDtZustMUvkLTd5wi9r2zM5zY7vM64Hv
         +kBTuj9dRvt2mUkSEbS+X2zC44xlHRe5t4pSMs5e+8JbmmPRnrt0bRlro7IoGd1Y0F8/
         VKzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774996745; x=1775601545; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOm+IZBI9Gyyl23ujT1K624bUaJ4CxbCURFBAGSrpjs=;
        b=HPLHAuHMWs9wnfGFQMuKBdezT9chwKz5EBDLB96AmajDu3T44R6m6TrLgi6/0GeNdB
         pHSzcA9xYWA9U6j6FduIXP8x+hcfyM+ZmOmkdLvV+kToUEYfTi7mslOwhZBnGGVkxI2h
         ud4wEngJ/5WdV4Px9K5LIY3Q/XxarucTlJxhYhJaWEbZxtxL7uvqxpPUrw8AD4lSTGfs
         CJ98aIyJcLWqej8O0jrG9USAwWpINtdrUm4l6pzdVtMLu9j/XHW1+ebp1YF1NoUwEB3i
         GXdfriC7TQOQQlB/ST8bYs+RWQiXCvLqN/kaTDpWigeDwFzF287G5X+aSWve6xUowJ3X
         oNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774996745; x=1775601545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nOm+IZBI9Gyyl23ujT1K624bUaJ4CxbCURFBAGSrpjs=;
        b=he5r3BSsMQUCS5Cu3VTJ59sZrxohofaCq5stJWrUgZ8ELj0TqyfihCGZ7sjxEyGiT6
         aM/94tznOOV3hofxdmUKDHbLVJHAgPLOahpSPWA1IMwo+q17sQeuHQPJ+5fvNvlP8IjW
         5TwUsx6QKDNHgYQhptE1gXO6ftuNJZ0F2Dms1BAQODTKW7Q3HduMtkG0OlwFCLIcWP+D
         A32X/y7mD2zzA39SjJFjSEESiMlLHT0GpdxwwlqleOBHGBPVK0xqzV+Mm7EIoFb/BTmn
         yTy9cpzXcZvmAPMP4sv2GrpJ2cOEh0QGyZ2Fn77vz/6hgTdae3bnDbJm7Ib1yR/UU0A5
         IqbA==
X-Forwarded-Encrypted: i=1; AJvYcCVDIl44wwO/YX6FqjRh14WpKdKKK37ahc73rxh0F5VimM9DfrE2xmiYO+y+rcaIOPwnoTnvuNG/7Q==@kvack.org
X-Gm-Message-State: AOJu0YwIOjyC9jeaH7zXjQdainTthg78LOs5d35Syd74hlLHF/LcX6V4
	dqeHqjGj+EMNtb8ush0tDwaGn99kur9KhNcBxNVNDPyf5MDBQXmCvK5XdHrS3M8PQvL2B5mIZHI
	ruTh/7XB+aU4XpUyaWjwQPJxBkHQI+PQ=
X-Gm-Gg: ATEYQzx9Sm2Gcp2T9KsraS6JYz5U9Fo+LNWf/ps0s4pNZdiwRfUFB0+0WhdbFFgEfgV
	4CIegOPiFZcniHm1mQYYL8HKB3HTaU9qZ1aNJrzXw2JmZX3xWHwIrtMgdbd/cs+K9CYBg+xcQaP
	OpbxaNBIPjJ6ifyOMOY62Q3nHHDmNqQxrQVnEs+5efdPzRqOJFUC0QmIrVilpYGUpXHKoVEKchl
	DjF/c85rCHRgHmvjt/Nj5fC2e7WvGDhkkifSBLXqL97uD8KqJWXP5kcsoz6tfms4jCjmr7WPeVa
	JKxu0w==
X-Received: by 2002:a05:7300:2213:b0:2c7:2cac:815b with SMTP id
 5a478bee46e88-2c930986704mr765776eec.6.1774996745436; Tue, 31 Mar 2026
 15:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
 <CACpmpofnKdfprZG=WHW-jOeeXGF47MYoCJDbkZJnemQU+x4wdw@mail.gmail.com> <20260331151950.54771bdaf8ddfac766abe3c4@linux-foundation.org>
In-Reply-To: <20260331151950.54771bdaf8ddfac766abe3c4@linux-foundation.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 31 Mar 2026 15:38:53 -0700
X-Gm-Features: AQROBzDxQK8fSuofgiRkgxZt65JE7WjU6Fmsn-Ki4NGw-eOy2FLQD-WdowmVrIs
Message-ID: <CACpmpofQ6hxf7OKCbC2LQXK2U-LjfekMx_KtLMAJQbVMs2=rtA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cnfgfgu3znxsdyya6jshzpof71oqudmh
X-Rspamd-Queue-Id: E82D420008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774996746-296402
X-HE-Meta: U2FsdGVkX18Azw4/KntgpeVdTZfGoM95vKfOysBzxemOWhpM5uff92ytHXoV9Xj/yJ+APItk1F2i6XQYjf7qlEFJUpqxHLNywj3KckDrlHZEW4iRER0hFgoO0Tyze3C6n3wSXDwLYYXQsU6f3ocVxLTsYqXCsHRJdOr9wmNo8wo+gnEHq63OlfhyP4xvaye1raKwxMyl8s20eJVWK97yP/woOKCWr0/oZIF84S0WXNlXKXPmOk7/X9v1e81b0Vb2kDKcoFKVtyDpOAPo97cee7mRxU5n94j7fo6wGH0DroQTTnNdEud7AySeKl2HiNvZ9STww6wO8Ier80zcSy+kJdA6wmxboX/k14HzQoHJIz567An9SgGpkikmvF+affJZVWwaWzzCSLE0t/hhEOP8p2xvCcFHf3LqCFtyZ6bT/MMmP/cHsx0jsf306ioNO6m761wQvkOrhpfYX32j6xA5M79tdDwBOcbMbi24PxBWkJdyWjTSaQRm4frHCsQCfW+dyj4hu5ne8D+MGYoGxFluyt5F2OTmsfTDVrRhinqYg9QSFcpn7yiS4e986v2ZUz5X3Qmt8YvwfgAN/rBI6zF36Y5gCHelO1hwVL2gUj+9U1tjP9Phh5Nvd/JFRYdzS6lefr7oXgEHehFQXSoxlQuMoUDRSKH872ExcrNFcplzlRMrzIln6dckNCU6HF3rcye5SmBMDQpNL2P4sl/7Tx+YAauLu9sayZAh7ziZiXIqHCzBJmNSsvsXrmAzjcqEV+osDgSvr1Ed7Y6zsNI83M30KTu/7H68GSSjNjVAa9I2xsUCZnODrl9XtXrpUMsLmy0FsIV3thb47+uJ05SpI/RMEGDh0g44cMouZPD1ypTCbHUxeJ2b6+Ig5DFgq+Tnq0S7yH/EvdQOqtp0VCIZoqWWcfPWKzmg6hl6KWfRBYMkD03c2QqyQFlQXwHDNgtpZL1h8LC1CVyXPfJiIDn6u8+
 1zypfPTd
 P3841fo7EGAzf5dC0y/wevPoi/aMzeRtntC/j+DI2CkATpRJYIQ0kQ2XzDMqPX54M4EQ9Rb8WXpqTEkfcnCgMuvBAt6uq9ky7bMge46IIawki0ZJOMjQv5o4tNJhYaukBP2p32RKOjnocqUeNt9JEGI2IlcDyMANaUcqXWmF+cdp+R9qWS82moP7XMGBd/xyoxWOGdb6Ld9hzhe+N/xLdBa56Yq+rcfiSKnmyv7a1FQRwFG6Kss08SFHw37uSmS2I/tER5CeVA1QOtNbjlbRpyvuZIl8djAxFYhZ46ldlEa5lnDdhGaw+wW8WXK1HIwN4lqy+D1KPPBmReuI8+XbxOZ/W+0QjgHzv5VuYxscr13kmuy5bpdbrry4D3Xg2tsRzPGFmyyqMaIJDTF6TcOP22fZlk9J3CFXBicj7CZ+1kjna57D85bDLvVseCRnxSUKuxKhSlFtfxSelia1Xg2spRnYnbtdhwYOeJNkC+oQJLJBTvVQehFIUweXGy/edBJVZRMQmxXc2JX9/0BSgYmdAUiLUwT5Lb1440nMgo/Mo8jmlFV3Mg+bCc5nyOwa0MdMLuHHM5knPhoSBaU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:19=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 31 Mar 2026 13:58:37 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > > > Kanchana P. Sridhar (2):
> > > >   mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
> > > >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> > >
> > > Sashiko was able to apply the patches and doesn't seem to find any
> > > regressions: https://sashiko.dev/#/patchset/20260331183351.29844-1-ka=
nchanapsridhar2026%40gmail.com.
> >
> > That's good to know, thanks for confirming Yosry!
>
> Thanks, both.
>
> I'm surprised that a patchset of this signficance got through AI review
> without comment, actually.

Thanks Andrew! I must thank Yosry because he pointed out end cases
that helped make the solution more fail-safe.
I am also very impressed by Sashiko's thorough analysis.

>
> I've confirmed that the code changes in v3 are identical to those in
> v2, which I removed a couple of days ago for Sashiko's benefit.  v2 was
> added to mm.git March 16. So all good, I've re-added this series.

Sounds great, thanks again!

Best regards,
Kanchana

>
>

