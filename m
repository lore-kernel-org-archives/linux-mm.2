Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31766CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 11:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A306B008C; Tue, 19 May 2026 07:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DABF6B0092; Tue, 19 May 2026 07:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9576B0093; Tue, 19 May 2026 07:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5B16B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:56:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 060D51C0EA8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:56:59 +0000 (UTC)
X-FDA: 84784018158.17.18FB7D8
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 087DB40005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:56:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMf0ELFX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779191817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0g4M9AwC7lGnFpPCL4o4ENFpxhGH1Xct1yAvGUVVEvo=;
	b=NQBUCZWOL11eBNRde41wvtODVH3YXv/SYbGgtYwPq+EGX9bk4f9ATXHLknkZHw1D79RS23
	asTjqvdjFf5BeXiyBwwgvryc7dGCUYl7dm2lFpRREgdj1PXusIljnwXtHXxM8Hb808qYIZ
	VyQLhfIL6Re8xzt3uWqzbEg2TzaXHh4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779191817; a=rsa-sha256;
	cv=pass;
	b=lUNqtOpSsnaRprBlNLyGAk8+Cc/J8K30CXJrrmDN58ry5cJvSm+g+Ff7il8er8Hx6rwmat
	PciARv5AhV1BeQn8pYfyGafUBCA3deKxc5nfz/tEEqpeTqy7jgjEcXsYsOUaOAocE4jMRj
	6aNd5fYcWa9G2vWKe8zMlsLLaVvgHHI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMf0ELFX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6802f9c5debso8270217a12.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 04:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779191815; cv=none;
        d=google.com; s=arc-20240605;
        b=E1UXLsPAdrBxo3q3XU7BZV0ZxZbfNdZ3H60sjTnjUx3PoYPIlFsLGKsh8Cg1BxoceN
         W8SH2cLNpUUgw2ewDC4+Yxmgdnos9f7U6Bpgb6E62l5M3tXjZpbfVFPZfqRoCUhyCYoN
         8MFKCgiruf/WyuXTBUkpiFmoyufxxyo1+zARIO16z0e05kzn+6Dok5U40kM4roOuCBV6
         nWAmhIvRkx8spbKuyH1esN3IzT/t4fcO+gOFICEUctFMhq4PeNjxhRCjQPNVWHEvcHqv
         hsFt//kgGyivmpDm3BD0BvilTScE8I326X89fUuNHQlN8hxCWThmOdA192Nh7rGfvhdW
         6+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0g4M9AwC7lGnFpPCL4o4ENFpxhGH1Xct1yAvGUVVEvo=;
        fh=+C8woGPLEDsb9g1dPyG2YSZy/yGh6xtG96sHgzm0VIw=;
        b=Kdsmw9oHIHoCLjLDYPimBMvdpFfZOXQD1kq5wzKtVvhBYUch9amHrc/osTwplRXHmp
         dKyDB0yjXCQER77KKuLNng8EQ4xDcHE4bx9KAgCiQYBe00CdtQD4vLPV/yuHcoQ9yMOn
         XWeQLDcJ682hFKPK6NbePBATknQgmTZko+dZTII1PKVpBfQupgmlfwl2WKXivoNDHJAZ
         eMLTy13oyFRcpG1BmXd1CdQAWDz3/tmYX970RcWr3e4XRAeKu9bbNxILmOBRo0+rj+bX
         eEQDkMu7vXdSZnN7mTrtoAhsiAxl4+Ny40wRu6BCe9ntJpFw/P1ixYhuKQg5O8xhBlmw
         bTkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191815; x=1779796615; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0g4M9AwC7lGnFpPCL4o4ENFpxhGH1Xct1yAvGUVVEvo=;
        b=QMf0ELFX0Dj5mY/NZTAIL/Kjpo31g5mnbf0tn82tDC/e8TThO+bnupRuJWW7D7hfAi
         eCUYruCbPwRiK5a5fNVbRwPdgGx9+jDn+IYTcUlcRzZAmFJ05m7Lh3IQcp4ExW8p9dcR
         bForvKJzkMdkuYmKlBcmkrT8j3xSFoTNrvXbi57RaACxSnBDm5sBn7aqJ/FU+JJPj5Ym
         sDVNWtvip17lTyO4uk+AUTehdsP+RWkNahHoyUUoy75BkhvxsC9IqPtVb0UnqHtKvf30
         0CUasyLJdINiVGIs0u786m8DiIklrekzJEnXZ2uYpkk9uQ7jOZ0CsfE1emaIZe2vFdtS
         uOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191815; x=1779796615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0g4M9AwC7lGnFpPCL4o4ENFpxhGH1Xct1yAvGUVVEvo=;
        b=A2uW0olkSfLgtKFP2PP9lK7eoCDK1+0Nteo63oJx8pTu3t+udHc6LPMHnSE6wBSX2y
         cR4FjBPuhUGcGZuhBVHT8s9CUjklZDjAGyo21u1lbfLNegoVKxMnqJnwdQ8uzjWsOONR
         XEv6Mmr5DXz4UUJHzPzm0Gm09eWPSwHm4+ZatI7J4+J8gtSEt22Zg5LF11OxP/IDdF31
         iK46M1pHkNeKtQftzNnVKhNsYRH16tbZnknhYJ9WT3b2d/+EMdwklX7C3MnugX7WeAJ8
         tZkLtWDKI7mSBhMXLrsIC2DofP9Ph4Whs4n8BD3+Fwi4qrtHzZBpwy1CohgF5cbysTyf
         Pbjg==
X-Forwarded-Encrypted: i=1; AFNElJ/wV7Qfy+iTR9gvupDGHIT0UhFbkrHf9BwB4rfIhZrn8w4blk7t3TCp8EHqYsU3anFKd4bvjCpJ1A==@kvack.org
X-Gm-Message-State: AOJu0Yz0aU2skNz0vZRo90xGb7qI0LR3vC8ceNAmrxKCFJUv7snDYmeO
	HFD09PhsSbuGKOuJWokuT5jqz7PCembIdngF3OyCuvt628lVVFsqFryhxdRlGj1DdGX9yrd6f1R
	I32xwxjUTKqb3/qVmKwnM8IJuETp0WUA=
X-Gm-Gg: Acq92OGvgKCf8B9aLRgeD/cK0P4gTPxKVMHZZVA47ZB2N5Cvrh3h5UPgP30BhvOuZ+s
	U63o406q4emxW0CsG9Wu9T412Utc0/k7GuJPhQXtxslyXW9N51CNWYBPZCrf+Gdl8XPkZA+m0d+
	VdEHdVnKMFrK6fWmKsPqtuwlpdUUNgqjX86FMDzd6vJRk7lqAR373NC+umfw/E9y5D6XCZGkdOC
	FZrFNPX6rIWauO4GUI5DzI0iI0k7wccKfCZOwTr6apB9M9H4JWptOWwptwXQMzlLEg++j9CwcLe
	GfmrEJWAl9QZS5DT19D9e+yXZQHEKhukEo8duA/kguLUGqqidw==
X-Received: by 2002:a05:6402:26d0:b0:67c:1ed6:2793 with SMTP id
 4fb4d7f45d1cf-683bd19552dmr10302017a12.22.1779191815146; Tue, 19 May 2026
 04:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260516182126.530498-1-pfalcato@suse.de> <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
 <177918418452.771415.4371785688744608623.b4-reply@b4> <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
 <177918837114.804096.3977912252785122973.b4-reply@b4>
In-Reply-To: <177918837114.804096.3977912252785122973.b4-reply@b4>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 19 May 2026 13:56:42 +0200
X-Gm-Features: AVHnY4Ix5KXOgZ3E2Av7fgjFxYK1xF4MB2dvKOSFH7WwrtZC8ogQ-bsbWF-pc4g
Message-ID: <CAGudoHGSZOEzbXHOAGqrdp6D06JQQ5Af759TQ+HiQx7=ruQa-Q@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 087DB40005
X-Rspamd-Server: rspam04
X-Stat-Signature: epysy1zutyru4ojbfg3coiswaarzrmip
X-HE-Tag: 1779191816-597291
X-HE-Meta: U2FsdGVkX1897lfWAHkTRBGciaxK3RrnCqfBA2G1DIgC6nAY+wFFiPdDHnT90jZN0wI1ZVJw1cGy2r1cV7qx9efeBmSpi4qgXFbS3s2m1p4c/ZwDDvFkBFT61vxRIbvcZ8ofXVep4pPmVxQYLMYKMo1xA+zPUwbGEJTpWNUkoM+QwYWqiqtzbwwfRsD/XKHifr9DAl9TIDto5EkW87Rpd9i61KDV41DKRksS+3c4hO7wkVgST8KUsKlw/JRp1H8YARwKvIwR3U38BPmGUQxdKbMOm6zB+0qckomWq31vpEx0MzyXI2SNx0okIEYOi+wOB78YKuuYN0ub4sfZAkEd7M+WrttAaTSH2uRLjLLRDnseDk4yefW1ahEFYCCH/xy7Du9SIz4IA3sdjk54UyhC+0+zm9XYnyva5/zBM0ES9KYyoPVJeRen5WvyVasoIfeVpi0ab8SO1sgwYxehZ//X+MxRWQUqxMNyEYLMx2Y3zAuKG/AaOe7AEdi46Ejklat7yalzVk6NHznM8eweRJ+n0GIfp9NDILHsVMY3ferXdX+HDPCDMct+rPDSQiiIbtFOz5fAi2PziYyXdYY1K2tpH6rcPqBNIlv4z9NMM3HSfQsXyoSTU/YJ0ScSKC/Tfk407U4brmutTCNLi47p86iOoCYDwkOZWN3ZuawQH9LskrBfWrCfSLE7y5bxf3JkAHLYsjZfYKQQ1CGEna/JfKQmEDOIgaun2XUAIhM3AxPna5PRjCLfWqdf7xh80DE+F+sfl5tw736V3aWhAx0C90RS8FVXLy35a8vFDA+XPaTU5bPU2EwmuVEMG3UvKhq5ZRUe/j2AAq50TWcChpqhweAV6oD89sH7+pznusIKU1Q+ohiibYbqKH8IYeYNEXyCTuyrwEdy/n8PPvd06poCQ8vyswH58HP+vZ1INTDJSJUStg5PneXVZ4BjYhxfuk/ODiaJmhJhNYrtC+eUNsX2d9o
 qAXpPm20
 2qORcPLq25/40P4OUqm9ZZoNfrEzpCH9cPVNodzcG5gfDGSYtmXvixoTi22g2C0zcmXRc4pEVQvQZvphconEf33mefnaOcIEXye512A+2c8VDRfMLTH4vYAi83m0I/nHZQaxmjupzm1c7n0AhsiLFcVR/3BtMR/12f8qvccMhNyBstMZuRWvIajdKTisxUbGmdbAjJ7gh63GmZjE3aSx4gtK3U+msRuBeRqQmvkTVhhTyK+imLGnI5lp17mxdXn/yFvaTQzo6sCOCmAgI9i2ggqGFdzGIyyyysViv5DqH0MbhFuY09mDddl6u5HVITyjCK0PttAPChzCH185eUY9NN+t5IhajmS0lfNjyfO3WHWaSlexjewdDqUutNyPPVxAygsZrGxjt1Qx8msOg/11oj58Oiu+Hpx2D6ouX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:59=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On 2026-05-19 12:51 +0200, Mateusz Guzik wrote:
> > How about denial of splice usage or degradation to copy are still on
> > the table, but based on a different criterion: whether code involved
> > is "known good" for lack of a better description. iow the kernel would
> > maintain a whitelist of "safe" cases. Random-ass AF_NOBODYEVERHEARDOF
> > does not make the cut.
>
> I had thought about that to but I felt a bit iffy about it. You could
> envision an FOP_* flag for this:
>
>   /* Module may use splice-like apis */
>   #define FOP_MAY_SPLICE          ((__force fop_flags_t)(1 << 8))
>
> But that doesn't address how fundamentally broken vmsplice() for example
> really is and that probably no one should get to use it in its current
> form.

I never looked into the area on Linux, I am willing to take claims of
breakage on face value.

In this context I'm saying the functionality is used in the real world
for performance reasons and just whacking imo does not cut it.

>
> > Common-case usage would have to be audited of course, but this sounds
> > rather actionable and would provide hardening without much friction.
>
> And that's the usual problem where rando module will just raise the
> flag. Maybe that's fine and we will keep up.
>

If this is a genuine worry the whitelist can still be introduced and
managed by one person (Linus?) very easily. The implementation is only
mildly cumbersome to get going and trivial to spread afterwards.

You could have something like this:
struct file_operations funky_ops =3D {
....
};
VFS_FILE_OPS_REGISTER(funky_ops);

This would call into a routine which checks if the ops at hand are
allowed splice support, so sneaking in the flag wont work.

The vfs layer would BUG out if unregistered ops got used on a file.

It would take explicitly malicious action to bypass the mechanism, but
if someone is doing that, they are presumably in position to introduce
vulns in another way.

> > The huge attack surface was always a problematic position to be in,
> > but with the advent lf LLMs any unskilled person can drop a 0day and
> > the position is straight up untenable. In the long run there is no way
> > around blocking access to code by default, way beyond the current
> > splice proposal.
>
> I see this is the "let's become goat-farmers" portion of the message.

I think this is very much salvageable, but action will need to be
taken by a real team (in turn meaning a buy in from a real org). While
one can boast about some mitigations, nothing beats not allowing given
code to run in the first place.

Poor man's initial solution would be to check lsmod and block
everything not currently loaded.

Longer term *something* will need to be implemented to fine-grain
access to code, including stuff shipping in core kernel. There are
some ingredients to do it already (seccomp and the LSM framework,
maybe even some of the currently available modules).

With that and money spent on auditing the stuff everyone has to use
anyway (vm, vfs etc.) overall stability from security standpoint would
be restored -- a 0day dropped against mod_nobody_ever_heard_of will
stop being an emergency.

While I'm just handwaving here and wont taking part in any of it,
restoring stability from security POV is very much doable as far as
engineering goes.

