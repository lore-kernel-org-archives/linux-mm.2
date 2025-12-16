Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF88BD5B87B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256626B0089; Mon, 15 Dec 2025 19:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D446B008A; Mon, 15 Dec 2025 19:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101E06B008C; Mon, 15 Dec 2025 19:19:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEED06B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:19:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87A895893D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:19:14 +0000 (UTC)
X-FDA: 84223424628.07.684C4F1
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7DE3440002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:19:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sojR50nO;
	spf=pass (imf11.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
	b=ThZlOuFhVMzdfshv9WlR1ZyC8nGz0EK7JnxWxyWukBqt3RpfB4FuOWZIVNLtX/LTQwRCBQ
	ZMQwpEXXGgtgDhH4NANCK7qrYeA+rD2O0XW5KJyChCGYWDUDUsU3Is9kyoAv4Fg5Kh36pN
	UwFwoEr7eYyKO9hUdW5635kV7RqhC7s=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sojR50nO;
	spf=pass (imf11.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765844352; a=rsa-sha256;
	cv=pass;
	b=YcNowEJ5B7EUNFp1IPBPK0Ev8B91blQKBKq4dwCep1kPR2+bTerI2vBuBkZYkWB7z/AVWQ
	gvdqxLn3A/tbpAk7L1/5a/V7NanHr6CHECRxNKLDBjjgFEp/u5Ai3RENDgJtPF/Yl2Mu8j
	cAhjwJXfrYtfacA1QzCM/u0FsWFEDSs=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29e7ec26e3dso47145ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:19:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844351; cv=none;
        d=google.com; s=arc-20240605;
        b=XCiBRTo+KQTDA45czf6R09YyCWO2jLq+1kGueHukhwUB5XK2Ks3oXg15pIEDfR0FD3
         ADjWUPH2fWIKSE5sASUCVr22qRg5Re+Hks/v0B9K/7MUa1wJJyORoQwC3AeIac92nxeB
         s3+IF8LLdXhtkLladAtgggNxvf+8lJBhjxyJ9UfAp9+PobWi4jjaiEjgw0L0hBhawlrm
         XMT2aTnHQJJboSgalBHuLXmbQTYkJhJJXFrL1aTkmeu98j78xW3IPlcWieJ9+5ABtAOU
         7U/3yEIY43GGOkvTr3GGjUqGLPwF0SKzyJPxXkWGyDAIHFvPnMqLCPnR3nz/WKf3K60u
         FlRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        fh=iqdj40N4M2eZmz9iJ8yWi4C9EbLwM7j1fkxHrEW6KJk=;
        b=b+RH628imhDXxKWjhQTn6NG7eiEZ9Hqj4KTuByLx+MPTLGTRFmETWrhoWHleUeWCcW
         dOTtWvcIiLz4PC10B42TLcn/DzJ0VBEfW0KiFl3+SZHQITsrykYmBR+ZBhk8nxZwpjGK
         sOZG8SC4+rsqqmOXumnYindyQ/pS1R4YiSYLjUyVvDs6ef9PA+ojUHrk/DzPXQmn1BCy
         knpppG9UAktHuHM14CPeEBkghlCVrmYaOe9DhAkdcmvceK3NPhv6lSHu/WLEkRuhPjxg
         gdgaxqH5fucWVt0sPGcW5u9SObNWOPm6LSjIcKkPzazpY5BBxS9Pl957z9wKEcHhkjzk
         +Ysw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844351; x=1766449151; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        b=sojR50nO29Lzqztc7DdZfsZ/lBU8ZUMaem3WisFQgt8AZzsPr2yyXaZT8S4t0MCqXx
         zCH9B3dg1LdqKGReGpiAMSBZyERJjLk9AVyBhQsfYx7R4arHuITHXSZ6UAcyNap8gpYd
         Kl9MndOPRJ+1yKEuraC844YQAGDFe7cLx9MztAojTnI9U3wr2hhOM6hjE2eDHOucY1ol
         7OR0fDJGES4Z6x5HhVcmsW0mcVXXBJD/S8aI6MCFapWEoR3vAmJahL1PXtonM+ogCv98
         u1yTaT81bHAU9beG4hKsuzD7dNHmWhyltHhPx9PxrbdGHjo6W08nzRy/k2dauvRb4goL
         gsbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844351; x=1766449151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        b=usT94kTWCHSWDMwTTqaqvx45Lhq0l6fMhNSfKejlRIKz4KWdSvzpixSope2sgbC7V3
         EoGQb7vmAqIn5oAqXKOYwBW6oRmHIWpEwiIvxCyO+1sEsY3Lg+Ucl4Ac7XSMf+TT59Cu
         TA4xOb1ykzVpOFkWQI1wQuVredf4nm5MsdqmYr8Hc83rVUOV8GG/XAZlFHu3k5N4HTaX
         vtXoQw1RBwKhzVqN84Fea1zKxoo8Qxm9na1GVt8Aq0iGF17YVfp8XpQIj/80JmZqIlkl
         Bjp8Ga7YRT+1WVNIO6DTZ86ZvCeaqsMIvKg1IAE188/7Nm3hhROb8q4jbJhpPIxr/LiX
         3r0A==
X-Forwarded-Encrypted: i=1; AJvYcCUYkjSw94yYYU9vTvXUkmpZNdXMJDs8W3CATbc+axW7e4OT7iFWvwRFrxLIlg3y4D28wAfxpUr2pg==@kvack.org
X-Gm-Message-State: AOJu0YyrbHtlTyWCUGZH+q7Q0prild16E10UHJsd86XFqR8mlsf+mbB1
	g2CYWPRh1Ot6bwfwrJelp7LpFrxwrFhYbxDzpk8WF9flCrYP+dwyuVzAzS0WFQjP11X0epMor5F
	O7s5paJpSeeGFMEu+WWv38u0MqGmZzFOtuSPOxbXW9tNoITFGsDPxb8/+LHY=
X-Gm-Gg: AY/fxX77gGtgg4Etmm9leqHLM8Dl6NK58s/vZqydTYAtSEZYEVlCwdS8YK3Ohkyc6B0
	jqGpXkda+QbC4TrUsHdMgzKiO7u4uPItKHgYBTazsfxbZaIfYIzBOuGYdX3Fs0DOli9hBXtZ02f
	zrBb46/42Bswyz0uqFZN57n0UF9+U59BquMIJIEkykxkJsKVsSfOP0LIwXvxb7Vly4kA+ieARJP
	sknJvyocGmMHcJTOmILG21kl2gTCqVXj4DIk2SL0IC4AWH7MkiUAbA2vystsAvJgH68Wyyw4Vt6
	61kp405r9J3TO1nXdPfmxJB8oK/V
X-Google-Smtp-Source: AGHT+IGBM7VWEq8LinkBSYV8x5ESzAOrR3yJML1qZ6fwh89ve8A15rNzyiEn6zhpcZCGpp2XSo8wGtGea9cBBpvSm0U=
X-Received: by 2002:a05:7022:988:b0:119:e56b:c1de with SMTP id
 a92af1059eb24-1205724808fmr225c88.9.1765844350465; Mon, 15 Dec 2025 16:19:10
 -0800 (PST)
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-6-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-6-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:18:57 -0800
X-Gm-Features: AQt7F2pmUo8h-ojZ6qUQhapMaawZOTdDVwOKAdoTYFJZ9Oc6NFfbzoMtVRYUIYE
Message-ID: <CAGtprH983huiuu9w9JG8nL3cf5sa_FpJjEt2gOvVUKgGUxtdGg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: g3y6bh5athe1jywsm8ymq5uohgmke338
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DE3440002
X-HE-Tag: 1765844352-263674
X-HE-Meta: U2FsdGVkX1/O6o5YF0H9dnTDHYqB7Jo4Iy2SXFJyMej/hwGBm+X7xud+w3GUAGuiR3BLVtcjWS2Y3jZU0s4eHzF55wFuoypMmYf5G4I/ps2hB0ER11wYzIoMU1/gZIuv3WYKrr/qxt+A4FTVNQYGfPecs21oCAAoANsu6KJHNv65AMAQHVW4Nrv3b/t4+7Yo6ywXSi9uhx5QfRvLzFAyt69WNMimFTf7DLFBn/OKnBXqXKdHTU78Zse3FYSDtG8sD5rq5WcZrij27RIJxo77RiMnaUZQPi6/LijEyJ7PeLfxqJq960IT2g0vhRty1gj5bXmAnpAVyMM00FOqxgXezhSTkYg+dbKPHDAEdMViTwUQWSflqkOCI7dFZu5p9sLtbRWU8LqdkrQ/1VKS361X77AC8AeS7Y0JYWhLEjLtdKLaGVAG5T0fxt/kxYADtBevMbBn9bOcIkEm61fgLBz8ScuCmV3zUqMkJBUaE5/YOP76qGFAJpRNUnlXX+6qJ/7eRmGSFF2hnU7u6sI6QS6+DOVyxBc1qiZre23vFLPLXsgEycVifmHD1Fe0UnPKp/mjl25Lhx3lcKoBaZ+5J3Q6aws/gYSGlapBIgPp3pbsqlPsTq2FjW8EsbUHlyr8Vy14iONK98MmryuDEXDp37QkYbGSgHsI0rViYRHmMufzDA+pZRlWrq7rlvjI2igs8omgdOJ+5j0MzZ51cGXr3nfoMXqkJeFPAH4K9r+k3nEcBZ5PEtQ7UQOTDunENYo5JbKo3/Tyv0nMTQ9FfmiplBfg0opvIPVCgM94KbyvQ65FR/hDcWUdtqkFFI12bHCmN0CaAriaq31tCSAATUhF5Nh/iFXZB3A2ozSb3XP7QmPWzY+jNQiekevez4hsF3hh/gp3D65DdscFWrjMk+30WF5i7wDg3hQGgkuCl+Cmvvk1HIekGxXDII7I287LETGmFQvTiLGaoNZVod7ndzwa4pG
 jOLtLZcL
 FN/xZ8KH48I4qreqSZcuworU5dlWUc1i+8wL5TwKwUMDHRrF3dSNocTqEcscdZmphUGt1/vs2dt1L8TNviFfdsGot2xq4wcDjY/X+s1/Ix3/OUqZ8p64yebqFAFwf52pTOWq96+AZ2UPnDPaNL4MfjzAd5Qaa5yIT8z0br8YS5mmBRYmn9JIObDP1lS2cVUECzpA9Fg0alUL2mXQQzGexlUtJjmw99+alrq1NfPr6SSuRuPhGUdZOhpzwKTry6g7LPEcwlU/Dfw7SKa0u5lqFtk9EkjjQeWs1c1k8ic4YIz+sanrqUmwISpDux5RYs5CJaApZ5pA43VrPESM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:36=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> Currently the post-populate callbacks handle copying source pages into
> private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> acquires the filemap invalidate lock, then calls a post-populate
> callback which may issue a get_user_pages() on the source pages prior to
> copying them into the private GPA (e.g. TDX).
>
> This will not be compatible with in-place conversion, where the
> userspace page fault path will attempt to acquire filemap invalidate
> lock while holding the mm->mmap_lock, leading to a potential ABBA
> deadlock[1].
>
> Address this by hoisting the GUP above the filemap invalidate lock so
> that these page faults path can be taken early, prior to acquiring the
> filemap invalidate lock.
>
> It's not currently clear whether this issue is reachable with the
> current implementation of guest_memfd, which doesn't support in-place
> conversion, however it does provide a consistent mechanism to provide
> stable source/target PFNs to callbacks rather than punting to
> vendor-specific code, which allows for more commonality across
> architectures, which may be worthwhile even without in-place conversion.
>
> As part of this change, also begin enforcing that the 'src' argument to
> kvm_gmem_populate() must be page-aligned, as this greatly reduces the
> complexity around how the post-populate callbacks are implemented, and
> since no current in-tree users support using a non-page-aligned 'src'
> argument.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Tested-By: Vishal Annapurve <vannapurve@google.com>

