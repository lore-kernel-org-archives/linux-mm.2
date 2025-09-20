Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DC9CAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 16:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668D18E0002; Sat, 20 Sep 2025 12:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2018E0001; Sat, 20 Sep 2025 12:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA4C8E0002; Sat, 20 Sep 2025 12:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 343A38E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:26:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD29283E86
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 16:26:51 +0000 (UTC)
X-FDA: 83910157422.22.BC273C3
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 884B440009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 16:26:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=dNdAWDYo;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758385609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvLRCncIiqRrC6qT6Y0+vbtoZaqXeTLbbsZoYra2n2s=;
	b=L1NKJh0rDBgqzg5nK0lHMuvL9dvSUUKlOX/VeEbPpdEr4Y1uMqZ4hp2CazlvRZ8olQX/rm
	t2sHjpQpwmjks0GHRCNle53tSBKgNvSe1GsY7Kfd8+FwNguGflVfrshk5eO0Nh55l6lYXG
	iA5mIxjeg9cL4sdBTWBf/qwXuYviPK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758385609; a=rsa-sha256;
	cv=none;
	b=KwjZqtdklsngilMQq1UBAkhcBZs4Hh4323HrpeXCme3YLXU7f1NNHC9UK037DMNdcUMh2g
	sSomMyJXihjtiy2AZnXUCDAq6NUqQ491XQTj9FMoM1v53+jaATMw6vMmetY2e3iPJGFcLh
	GX0LFgL1gJQUBRmSB6kVno/waBHPP04=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=dNdAWDYo;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b2350899a40so402026466b.3
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758385607; x=1758990407; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GvLRCncIiqRrC6qT6Y0+vbtoZaqXeTLbbsZoYra2n2s=;
        b=dNdAWDYoeqCVSRQHXNmpG0IdoZJOX80RrqE1Ea0GbthYRnrES3j1yz4kxBFIB/EQDi
         CU7Hj4PRyag9UBsaVEshwKr90tSLYzg0yiMLacYrACbbkkMBBuw8bpQyprEeqhH5cj4y
         OGucgveOLLmbA/OGBlc8xgbp/yMYJW9j7f+IQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758385607; x=1758990407;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvLRCncIiqRrC6qT6Y0+vbtoZaqXeTLbbsZoYra2n2s=;
        b=NFgWUb55LjFnBoaH23VCT5dhE0S6e9M2Nuafnufl68yRpa/ZGaIuI86F96ItG2/BiW
         0MiFlddsgz7Z3unvPpJ8jGNmPsjCQsTpaxf1GOSLtCNuEP/9SCdySu/CDUSqQr/ucZNS
         WT22X6G/JS5NfuI5ODtIWy9zbT5X0vVU8a80xqdL93CYt/AxiROvFLz3UF930poCZa75
         MxvApZ0v1P/GyVmqH+EnzgkWTjgzXBjjXHsENKp+aRvJYu4C6wWhZsuxtPyxomAuJZ+A
         9GWFnlyN99R6lNrV8KDAtxcf6lQ/d/Vcp/J8IRJZmLhIvA2l9Cs4ZKSww6WP6UvDp20S
         hycA==
X-Forwarded-Encrypted: i=1; AJvYcCVGtsTeFoOLPdvQYsz3lSRaNgs9CFMNrw12FX+nINMr59iyTZv/q4400qdAs1sP6OvGqolc7SUA1A==@kvack.org
X-Gm-Message-State: AOJu0Yy6ibbj/lIaXOVKxC7hK8HHaBXD/ipmSkAx/AAjpCQFcybCwaIB
	ugoYhL4CCmqXGc3+EstmvdjephxvvsdPe4PQpv2Po33x4arEhZGXGiRxQhZ02X4oet3sGlGe7NZ
	zbyee5zQ=
X-Gm-Gg: ASbGncv8nWb35mdyeEjTOuyxnLCnrKhmWPcSLWlNMncI3ziWcO+LcWlSxi53TPWUezt
	uxd6msJwFAk2Z2rnFlcIjpvCF9ePR7rrFnyO6pg/fanVxv7DLhok+DAjn6gVuKc3foonJd+2oq8
	kg0aWn4hp/d1gg/P8LxxRk8l+cyimvdQ6MKO7tmm2azQMHIXBVsSFgCDHnazYnlEsd7ZGlKl6HL
	GhUGfmhXWzo1hPPThOVRKuoVY4UQLDBdCHsJdTzucvLtA3UW6h9EmB/WloZY3BAlS5lLqW1JJ1P
	RGsfaZvhsPr/x1N0Z2GiR6PEpx+pbMcpDJoV/jUeJ/8CZlPIBcWrqwQ3vZLPkcFqy2lT6dZuF1k
	UlZg8jGe6++DfN38BK3+UB35qCTEQrVBELPIoscVEDBAgneNR4V6BIGChCkr7TpSpMOcwyRZT
X-Google-Smtp-Source: AGHT+IHd0PWpJ4JwLIV+8FTpvKfLgxoyLrI4UbCAsKFa/ufwGLSHBqa+wDXtpPg2eXmTCpw3AtiHkQ==
X-Received: by 2002:a17:906:d181:b0:b28:9c6b:3487 with SMTP id a640c23a62f3a-b289c6b439cmr180935366b.34.1758385607552;
        Sat, 20 Sep 2025 09:26:47 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd2816769sm671408366b.106.2025.09.20.09.26.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Sep 2025 09:26:44 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b07c081660aso556203066b.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:26:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWIz2023w17K+t6nVkUUcPYZ5cORBsa/uQLNdbg6hTbdppcs/eRz+Id8mAMIelv6KtGE3/CNEU8+A==@kvack.org
X-Received: by 2002:a17:907:1c89:b0:b1d:285d:155c with SMTP id
 a640c23a62f3a-b24ed88702cmr706169166b.7.1758385604052; Sat, 20 Sep 2025
 09:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250920074156.GK39973@ZenIV>
In-Reply-To: <20250920074156.GK39973@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Sep 2025 09:26:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
X-Gm-Features: AS18NWCBuRxfjxFE7tKBAQqhhkva7pQWM9EJwSLVmis6atYjgiGA5eqHrxKhjLE
Message-ID: <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
Subject: Re: [PATCHES][RFC] the meat of tree-in-dcache series
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, Kees Cook <kees@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, linuxppc-dev@lists.ozlabs.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yd9wdga65wfpb1wz9skomtqr9nrot3s1
X-Rspam-User: 
X-Rspamd-Queue-Id: 884B440009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758385609-698923
X-HE-Meta: U2FsdGVkX1/67iQcoX5DKw9HQ2C3rkmKX8Q71VtOqmej8PcccJAz06ZGma95yectFhZwJPQpqcSKnzTMXR28fXREMWXdPFbq1lKMxMcrHDrkdRYyUCaDxjqQ0yYVmFSVUHcJiguH8nhW55gdITX75f2f9kcS6pMCXnoGefCJwYivlDgEnn/gDKuwod0OzppYsv8B2+FHcRK8avRnIYPDDSWNv2ZbBBR9UeWyIcd7/CZmphZFPogDu7WwjjDtvcB3eMruFF71eJ93MwsOJi59r/4K+0wWH4l7a+fRWO5j0mQie/lIgsZtdVGAp2tdgbTHWckjcfnejOKP8Uljxbnr6R4UE0QiQvNrGy1XTIwotkJ9JoLIGCU5KmPZG7CGV58t5tN7Bm3xGDp2ppwDvrIThoKDP0xcoAPsBODohAFE0TKrbj0/J3mmtQ0Ik7WfV6770+77vzJ3vtETc6i7fjfRJMYcddZDUgzScRY31wPP1t9XrPlzlnDgOgbFq+bJQHfJylYdtboC1IFq7KEoboCYb67Gf7OvtwdHdb7SDJlJXA8G4C7ji1zaOXFVVAEXnr41JLm3BX1+Bi0wr8i0qoAPRkrB//alzbsQjlWkdHOrRNix4cC3oJBkNrDphno8ZEfwbWiKquwFIojCjQ34ZOMvXntIWeo/vOG7WZ5hpYrE0lloA4LYjYT+Ikhf10fvVJp4zvsUXGzbdUNc4tZVCx7zDE8lSvHFQXIP7RoYCRYkkQb8LkhZpp2OFG4tCBkdswZcKdY3OKXWPl0cGKeeoUEMGHTKn54K9kpXB0CTA89lewmfI/sxWLOaoqXA7doFCFOl8ERyTgyZVvtyubvXbwiTnndSDdJGcb+RhatzAbi/KL+8RrzgXYfNF0N67MFPRK8FR6NCLa5t0y0MlyxGE2hLLkFfy+a3GCnB2NbGAtkxNMHsetwygOal5WZo0FXybHNn90yrtyL30MYKpaLAxVN
 NV2sHnr2
 dbvy3RzP2xo9clkBBeUOqC5rVkgSG17huo8FafretaDyQCEErL7pcg0M/fHJ/c18TO4KjbFcMDj9kn980niJVHQfIMwlBdNoYLRhdDL/jLtOkdFDIuhS8Y+vcjnbaj5u8zpjXh+OsEohbGQ6S3edVxM7XdUhKkMRPeRrWk0qoQ4I6t3x04ZvEF94oEx5Zcudusw1ZXOUvYnBS6damdstTVOCI3G5GX6KAzJUCX4/58GM8JPJCZiLldATZfXzSq5S5xAmUyMd/NCBszbtE97yf03ftUCk1/si6klRSWJuHQGs3F6gLBVFGHFOsMv0ScwD8Ny/IcetDdgssuG2j7Z0kOFH1Q6xvO920Yu/2nBFCqDDr9tCxBmGu4lEOnNTxFLt/HYbCWzIyw1DsLKxb3N8rZiXq7V3rUDISSC6pRlpq6eWuodx1+DVRA42WHxl+U8Iwnw/hIQAclxrmL/IRJOHx+w++CyblphxLszrmot7vOK5jD1Ml9YrOpAhBghR36BKZO0NUWP/m48GGay09WfNPhxLk8b3k3Xhu2WehQmdqyYlYvvGaiqNd7i8Lljaq0brgqydRrLSj6P0Q5MwQuvnf0QODZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Sept 2025 at 00:42, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The branch is -rc5-based; it lives in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persistency

I reacted to the "d_make_persistent() + dput()" pattern, and wondered
if it should just use the refcount that the caller has, but it does
look like that alternate approach would just result in a
"d_make_persistent(dget()))" pattern instead.

And I guess you already get the lock for d_make_persistent(), so it's
better to do the dget while having it - but arguably that is also true
for the dput().

I think you did pick the right model, with d_make_persistent() taking
a ref, and d_make_discardable() releasing it, but this series did make
me think that the refcounting on the caller side is a bit odd.

Because some places would clearly want a "d_make_persistent_and_put()"
function. But probably not worth the extra interface.

Anyway, apart from that I only had one reaction: I think
d_make_discardable() should have a

        WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT))

because without that I think it can mistakenly be used as some kind of
"dput that always takes the dentry lock", which seems bad.

Or was that intentional for some reason?

Talking about WARN_ON() - please don't add new BUG_ON() cases. I
realize that those will never trigger, but *if* they were to trigger,
some of them would do so during early boot and be a pain for people to
ever even report to us.

BUG_ON() really should be shunned. I think it makes sense to you and
for automated testing, but it really is absolutely *horrendously* bad
for the case where the code hits actual users.

                 Linus

