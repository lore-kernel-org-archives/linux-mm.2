Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A17B606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0r5lcu0N
Received: by kanga.kvack.org (Postfix)
	id 18A6A6B05B2; Sun, 22 Nov 2026 11:06:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163486B05BB; Sun, 22 Nov 2026 11:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078AE6B05BD; Sun, 22 Nov 2026 11:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1C646B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:06:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 612D51606D0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:06:30 +0000 (UTC)
X-FDA: 85463232540.22.614435C
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67D70120003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:06:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0r5lcu0N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795363588;
	b=5kWXrenn4Ghxnt8oA+hBLERXA7myb9biaucSbHbM6V2BCmlGoj/r+/xJXQtZynu84r+CTw
	DaxRXQkjPJgIeDxV+06lNXYOTAzgG7bVpbKZSx7hMp1AHHsq8bZ+jedyrrzNwiqCbw2nP1
	Cp89GrZu1EJch6BTh+mUJk7PxRJi+5o=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWLHqnr9eQ0g3Kih2Y86iBXbNbzuU8PKSHvSPjCQvmE=;
	b=Ujj44jy+vXriRh6HZX/7f28yiE/X9YCvIbiV4hflmtebHjmCPk/oxH4CqRKUDETlUCfC6T
	TyhzeTwmzwHeH7UvuOxU03CL8arBq4AKjnvmw1i6xKkUhoRRdeuzSOxVQLIX/P9QpuwbOz
	MC5p72jeVKihzeOekKHVEMFgOFcrUsQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0r5lcu0N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-57cc80785e0so279195b6e.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795363587; cv=none;
        d=google.com; s=arc-20260327;
        b=m17dUcZOn0pLYFjBNmLwelWbxwWbbA2HbKUQE584YwrzyIXGdsmyNt9+1KHagBLzsU
         d27YTpco8HWUmUygRV73XUbHu9hvILzGL34A9FBv2bV3wrox2/wzA8jBp6wUwEYBowvC
         eIpkZa7n9qJ5rVheyy6eRjpB+qIShu7LbxAxlAcpGE03e4tCd5tNC5H+x8b7/nyjYA/1
         4To4AUddKKGAihvpxP5VWbGUGz21MXtTPQXQuSbZ2LhHTVEkm/lrB+SC5BL+z8gtSpOQ
         +k292ExK0p1T+ih0kw4HakdLkVA+/OAXUxJL1fGGdJWdjarh4KSAnHFkx/nsUqoKjG4V
         Qo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JWLHqnr9eQ0g3Kih2Y86iBXbNbzuU8PKSHvSPjCQvmE=;
        fh=Q+mT6+WlOePJwtZYVDAd5EjMe/HSrivu6xdAjlPPHh0=;
        b=Ti6B1pW/+BCrSiKftXZz10+gdjIM0+UiFZs1bsNB3Clvag484lEMXVb+LLWLxrZ499
         a8c9or1PuWGaxz//4U8S6z1sxSZWRUHFwOIXjjKWhSeEhJWRAXAAV1ieTGN/AswjsD9y
         /fMOm+HBXczn+tDiKVZMXw2IUpeIm4iE9csjezANzOqhG/uatIlBdI7KBB8+9jwyot8q
         iwwc4BiK5T3ei1JcNFjNJsxaqpmORYjiAaaZDZIDaj6PGCaJ3810yIZ+XOt1FMbHmA6q
         od22jU2NX6SIMBj+CwmIPmTyeE478+xAUjkFCHDNNwkZp6SYo/Fp0VOanJA9KZ6tWTCR
         HQ3g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795363587; x=1795968387; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JWLHqnr9eQ0g3Kih2Y86iBXbNbzuU8PKSHvSPjCQvmE=;
        b=0r5lcu0NfRIIaED9PEwcJMLkpIXhAL0dVK+YsjO53ScqOhdOCiYKYLXjnE6yo4yjMP
         0e4H0foB5FDUpOeJebryu4Kp2NL/yTGO2HrtJUqbQ3Rn3Q+H5HOhkL1z++fv+kGu5Ukh
         agaUrbv9g8ALncEUnKf0Xm5AvGqqYQ0MNRNs08mewCWMCDfWI4oRlPcV0XFknn6RWa6y
         brm5CLCaJ531epa1bk5TXE9jp2EmgAEtGb97JRph8pvje8I8xUk+SKIma95r+N3nZKkg
         ur87INxzaR6GT+MWMFcCFvLI5PsnmVef8eTBrDpdDeEajoa3Plu83Sispu3xYQfOyKKd
         B3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795363587; x=1795968387;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JWLHqnr9eQ0g3Kih2Y86iBXbNbzuU8PKSHvSPjCQvmE=;
        b=At7bfzGNAKlKonS0LxwCKs8KH3CZQEUH0pqCywiFScOXEUTsZVJ7KtvBuYE/cLiVzE
         U7x/2BPWxiF/X+JGSyfLRVdURkeAA0C/H/SLvR+KoxNCSfpIV1G9qALiZKJhTriRWDGJ
         svvRFs4RcmJwXoZ8dUqtd7blnxjSfXpEqZE+FaQEuqkdPj6EhiwxKIgZ9pjWoR4XGCJq
         fAqqiSQTp7EoOTJjsxjhOxAlEB0ZORHzfu2EC/5/Hb4DuENUd1h7hBOCgcYMVP7HW3Yn
         Mn6T2AVWXPfDKCLQphK6YPS/y4kvyDcZj6O8+l37zmmCxdTOcMqxIAoVKhO58egSYnA+
         M9OQ==
X-Forwarded-Encrypted: i=1; AL+hErHjzJTZWqzqwLS3KW1iDFP7xevsxFen3RcoRR0G1bzrrs9P+yxpn3U3RjPkeYUjpVFsXxmSOtviEg==@kvack.org
X-Gm-Message-State: APuU4Z/B8KYmjJgVwzU5QGBCQTI/h6VgTy5EBLC0CV6MvgiAHJduPh/3
	gCLns9YCvckZVBKxp4YvGsjZWPiNx+L0HbHXx+N/sjGfrBnYEDRlS+Sh10cxz8ELf+vab1XSGTb
	3NPt9W3AFlvkMfyBwOma/4YaSS8MlqJ4=
X-Gm-Gg: AZFdTZc3L/dsPI0D9nX2uGsw7CL5IVl/JGVwvSazckYh45II4hTOYHht7eKkOLCDKeD
	Ux5DzDulNt3RPpoeyFWy+9H0Fq5OVNrlDeDcqSukThHzKI0AUaQO0Z0cGoCl13LTmKCzal5juUr
	SWCgVsLI7vq5NI7g1AAZ7462IGzU9Js/ocmUMB1nF8Xzk9bjC+Jejo3HA+VfhAM64QAnxVfjfDO
	hUFIHKBmrFW7VFs6YNiGHP1ZnpklDfIWf8r+tx632eV5XvL/y8AX3VZvR+JFFhoaZY7iAQVPV0+
	RxTAqylZmuEbGyBg/ZFoEeMcb4kMUAswIklhYRuqaRzkhvFJ01v+Oi/ff7SZVppFmMDeZxQMeHO
	0XgnVGU0YxjAjRI+uFvAD1b2796ZjFK8vsywAevqHnayaqlqPMW7w2kuckgJdASzjLDodNGbQtq
	bqyLOP2tDnWzg63t1/NyQ4/H7QLzPM2g==
X-Received: by 2002:a05:6808:191c:b0:4d5:27da:a492 with SMTP id
 5614622812f47-57a0bc8d4d4mr10610217b6e.44.1795363587423; Sun, 22 Nov 2026
 08:06:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-4-sj@kernel.org>
In-Reply-To: <20261121210013.130397-4-sj@kernel.org>
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 03:06:16 +1100
X-Gm-Features: Aa3M54p7uFGEPCPkwkXIjb0l62MMf_8Bfq2LIyaO0NY-QwLa3_skxD1OEKyAMRs
Message-ID: <CANOyQmH5FX18LmMW+QwAcvOiATgUqx5VH02S5DyfTg+qPMSX+A@mail.gmail.com>
Subject: Re: [PATCH 03/27] mm/damon/core: introduce damon_submit_report()
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6yaijxcobrhpa354q7jekaw1dr8ne6bj
X-Rspam-User:
X-Rspamd-Queue-Id: 67D70120003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795363588-245773
X-HE-Meta: U2FsdGVkX1+sHDKG//RjNCTqfoAIiXkRvu6k5tE7lqtU6UPd7WbCZc/zwyRKRHoqcY/EL4pSlRV4enthtovedOWOwWTG6luvg5FZdpokdMKsUbS6PEtgYfj9YUetvE7sf7bf2OCr0P6QHyVOn1QTzqO3CcAo8QmIgEUaWHuZ3Sez3o1PwStpHmd1RHSPXEpFOb4KRIAHNwiQOv4wBmTftYnLjB3QF+SFKxq6KyQrMtkacO6AHRGeX1gL1FuKMe+xCBplEXI3lFHPaMpBJjFUSudOvFNOf4jUheCGppBabithOgUSLLegRSmZ3UgK5jYqM+UaIGbiPXqFJl0Wru+twi5otyeGdmywcWLcnBZl1kheJo1/F1bO775SMDs4mgm+F7Z2xzVoqeJO1jeuQpRQm9gpA58Z0nGtZDDKtDvpnHoh6IruiU34g/zV4mReiB5P+yKwI3i4WpY1nSGnBfA7yFuSHR30YBVnk1XxJ8vnBUK3myP7Q03Ol2gCz4zx6Z1w9UbKjrWtMEV3wcwWPwjgAVltmqsBuQZx92RqcjrZf5nn3szdN5rm2BMjkchuUYLtS/f7yzGmeTVY6njA5VOgZDZokrlpHvo8xwWNeOLTlLSftj7oa9r/xBNc8FTPPkEXb6RqDtiDGlAZVLAYpswZEER+0jv+ob585tl0lD+GOvQbHezWg0C6GQxX2dBPN6pfvh5aNgGByLZ15R3r3nX1Er25fdMH+bMxKE56oRx20E+lBFSeuiMY4NvvWI2Fxuk2M+gpRhlbq2IUBBbmwM5SBUp64WvJPsR2+M8Ik4sYuIKjZZ/xKEe4wJmYm+MRvuur22T+Hlp+uN4OYsF5mCHRLYJAW/ZB86pfJGCJrkETlZ2n9imXUjdpB9Ne9b6TXbiILPTV81EI0Jbz7qfU8m3Y7VVJe+reRvGFftKv5t78SEISN5FEgiF4+ocEqWUX9oUfMPsLzoX2/njl/EEX4tZ
 eLa5Po7x
 ahq9JZMB3lkiTAFCMbX3DDa4d42KQbkNXRH5rspnZUu/fJ7L5C7uOqUEGO9U+77kHLPxnYQcM78BGNDbwhzYNniQv2+7Lkmswyko3N/kHNWjjqkEijU+f80lmV3AyXOE4h3PryPNptd8Tzxl/kD++fN0vay8wKbkI6AJVTg3YurmVP5DwFYxvv9xLXeVn0exVHusGFB6zqVriKpzgOT/rLemFEEmmipj9CZiIUTCLSAJtQiuNgzbmlpQHtol3qcM/IpcTsaXAPuFY1zBVcOtvGp6q5qGYMoieIK/v4WhAXOQIctZ6pwO7FsObsrTjDwN1vnxNNdO3CapnySaExznydPZlkweqQ4AhZkq5egV+cqdIAbp8m21FMdIf+M1HGmet/JiIdag8C2kSFhPABgqiPZ7fZLhUSmONiOMJyoiUPtqQo/EO4MQLFeL0PzU1lCqqznlXh33eEDSUmghwbBIIGwh3/TnHlvAY9/BCC+uKTyTTo3Mjmw6QNjGEldTfrY62RQTRGLqXXuxDxJBn17Qq5mWbnsobOU4Ec7wrFgC9j2DYAx6Z7nOElYaHLOWsZ3KN0pXenQNpab/XmauZlzU0Wkc1HSh6UgOoFrHwGAPjPzBoVvBEgQJ4y9hDcjPS/YvBqPFQ9kjykXgo3a5wvSThjOIZaR1fM7CSDOs2+HhXqaG3xWv5gkzp+B+aoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ

On Sun, Nov 22, 2026 at 8:00=E2=80=AFAM SJ Park <sj@kernel.org> wrote:

> +       queue =3D &damon_report_queue;
> +       report->jiffies =3D jiffies;
> +       lock_old_val =3D atomic_cmpxchg(&queue->lock, 0, 1);

If a submitter is preempted between these lines, it can enqueue its
report after one with a newer timestamp. A lookup scanning backwards
can then stop at the older report if it's outside the window and miss
the newer one that's still in it.

Could we move the jiffies assignment after a successful cmpxchg()?
That would keep timestamps in enqueue order and better fit the
meaning of "when this report is generated".

Thanks,
Aveline Noir

