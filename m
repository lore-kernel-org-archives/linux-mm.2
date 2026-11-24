Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275C0606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lIPDOfLv
Received: by kanga.kvack.org (Postfix)
	id 400B36B065E; Tue, 24 Nov 2026 08:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6A76B06A0; Tue, 24 Nov 2026 08:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECAB6B0701; Tue, 24 Nov 2026 08:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB6526B065E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:54:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E307160AC3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:58 +0000 (UTC)
X-FDA: 85470158676.16.DB8058A
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 740F54000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lIPDOfLv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795528496;
	b=FsRy3TaVVKnq5qBijHEDQY8ph4EuhpoSqOmGCz7X9qmdHjDkNiVU+c+budPLMllfdXIpBc
	sLJyjPb3a1a/GN8U58mQjk1whjfCm2hzXx1zoHOH8+dsaynb9oMxZzxWbmJIHvvlWXMzt2
	0sMnKa7+AzUo2mYDOM+WTJA/NYOl4l4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hskKhJvrkK2XwN7uok2JUgMgn3MP3IgOcFWu+hlmAzk=;
	b=4jJeKxOr07hpgNV9xn1zfF+n9fUct2Q69tHa0q/kGLFeqCLyP+7Aa+m73ZSAEnPxiucOrL
	YsbO1BSUKcXifE9ifo1iiYrKQViFgGfTK+MXFqwmpE7qey6GIjXVsPvB2/MFTn87TQ0lf6
	IdBeJ8s9OS+FeE6wOoL+vrPoB918YFw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lIPDOfLv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-921375f52b8so48863266d6.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:54:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795528495; cv=none;
        d=google.com; s=arc-20260327;
        b=oocj2hGNNWkxSJrAJadYOClDEhNLfRiAkMSa3LQsCnpLawh+3k+juVpJ1zhwetRFUp
         r2zySE2nOv/EexSHpw7V6zjmdnZjtFwexarrUOPrnJIaFAfpnqcex6E7LKFbeNt1X2gK
         eDnpPKqoYYZXhAP0q5sPCIedBEc9VQ2EXyi2O9O7xtJaOty2AHJnA52EnkG0w4wzZ3nF
         bnfNlQhuRjWV79pLB9hZB/UcK8HR2VHcumtyamLigCstJl/pa8h4hZ2MLXaySA2QbxkK
         xYL13VEnQjCXu6xvZbzlYbGIJRBPu2syLIq0obxH24Gs8WNybQSQrtWelLqNXQHELqYg
         oaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hskKhJvrkK2XwN7uok2JUgMgn3MP3IgOcFWu+hlmAzk=;
        fh=xUq2i8zwsqNElCWC66WxGbNuIHDNznaGEv1hpEUmh5Q=;
        b=gxILn1lr0x2Pc74z/Y1AvF4OasqZ8oF1mhqFDxlDiS9mmvbknEPUNRmFI74TVTARZU
         V//XYKS0nIz/pBGHOAqfX/DshcXa81hC71L5wle1e+FtCbR4XSQzX8S4qPxt2ylR5W6E
         xrcHha0m/i9Vg5zkMVwCsYYe2oTkK9pRytQOM2MQHqHnI8NT74D4Sy6rgmN0Ize7+5HW
         xhqEIMztuRPXJz3HOjNhuljTn0fwSbY48uQTyIUwAXkDJw9N859h/gkJQ+QgiJKejHu5
         BjkEPCEtEYUI4fuV2zc5UYBG+F42ZzNfaVM1ljxb9uiKxENJ/JVUdjLKqVQXbNoOEwpk
         hVbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795528495; x=1796133295; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hskKhJvrkK2XwN7uok2JUgMgn3MP3IgOcFWu+hlmAzk=;
        b=lIPDOfLvlBtGHdorUoWf2vxtdwj3ZgKy5+/ShqH0BC6ns7Tf3mymmq0gTQvEvFo8sN
         CmTZL29XLuynmTNI2y5uTk4m6QW2t0Jizw0yGEvwSaHVysg1xtkTfUW9Wmb190O2M13q
         HJyxUpjOJkkdoPOYZFcpVApu4+BdUaw7AQ/ViBrvGZt3GZ31NpDagGxKzfaXGh7mWoeP
         hYYw7iWNEid5O66IWAOGFRUh70kiAZK91RsvGs7HmWmhs3YWkA/fqiC3yJFuX6YRtLLT
         Fwe6Hr894u8y1pK49t36QUq9649FEaCTk/G4sOe7ggRxAd+5ypyynxgppM6x6jafYULy
         uCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528495; x=1796133295;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hskKhJvrkK2XwN7uok2JUgMgn3MP3IgOcFWu+hlmAzk=;
        b=NPwQVKans8j15bRYdQu7dvASnq5JLEYULtLgj6rZ2Maakgomqf6pTrzxV8AoKtYIzX
         eXb68ptdNxD4KsLVRcnlXWUhzBmMqPXjMp3+en3OH819gbWL2aSuCR/vYjrTecKxZP3l
         0hpD6IGJ/rx156bZ+JkggAOVua3GJvNV+n8KuYz1JlDTAq0wiSEkvO6AjVoag6js2DAG
         Gqq/wFhEZzQHLLCZLGLrJcu+11UPMNwJfXxzbreb+I21hzhM83mYiCed8zcPipMeETCv
         v6ec/bhw6tmiG2nNTqYnxFM2G6hjlWDKa5OH2XMMYkSKTUZcZ20qZIRKnMyYQvx5DTB0
         rygA==
X-Forwarded-Encrypted: i=1; AL+hErE++08hOvtNHhj+NUVNKU2WKZ8SPJr+lUnl3WVAOYxrnISOsRww34Pm1uMS9hoTITM8R+DUrpyGlA==@kvack.org
X-Gm-Message-State: APuU4Z+lxc8D6uU2QwfB7EbSfVSzFsBXMfetSOjbGgQBw7SZnGMI4OIV
	ezjsj9kionKVvuCgErMP+Jgchlp/Zy2sxnyguuOoKRuGEi8FXXLttrJL6sPSP5vkfa3MJkLbbC9
	9L479HhO2aCrNeK7FOI4B4z3XQNumYE0rKjDsTkEd8NxD
X-Gm-Gg: AZFdTZcPtEMInLghMc2GMSw7jfhBOlTZ5ikUUk4nl4OyQ6Y7wT7foEeGD4drnHI3ruL
	02aywralu4U4WkDL4w2FaUIE7YXTqKzhCcKs0CaLdeSc1vetqQlxK8Cn1QfybHsCtCOJPQirqLW
	8UtPFi/czS3KjzySjLRrBexlwNNeQo/Tdk09IH5zQJ/7NUGdSr08AV+1mcADX+aXs8O3ak36d7M
	BjxxTyfYc29dgNIphDpXb1hJ2qKqfPazD6EhZ4uPsbXOaiVS0xDaLJaqhgSukAVIK53WBsTCoPs
	b3jT85gXlZkrpRoCwfMhx4mVuxKZf7UWFe7bUBRVnZN8QeYAJwC6b0jMRY5m1WqTWhX8ocATLnE
	7bovKmwDVXZG8l4APYZ/9thtFtTodMscnV6xw
X-Received: by 2002:a05:6214:6012:b0:921:2569:3a61 with SMTP id
 6a1803df08f44-92134ab82b1mr217590136d6.10.1795528495554; Tue, 24 Nov 2026
 05:54:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com> <20261124.225103.2152350984946270550.tomo@flapping.org>
In-Reply-To: <20261124.225103.2152350984946270550.tomo@flapping.org>
From: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Date: Tue, 24 Nov 2026 15:54:44 +0200
X-Gm-Features: Aa3M54r5lRaC6s6ZVOyblge65-Tre7sMwzRlPmQ59ty0THQcri0vIs804l2d-88
Message-ID: <CA+YDrKAv1_Ot0pmPuzpFuZR97pSbBVQW88RBs=DVNQ4W0OWwhg@mail.gmail.com>
Subject: Re: [PATCH] rust: bug: add warn_once! macro
To: FUJITA Tomonori <tomo@flapping.org>
Cc: fujita.tomonori@gmail.com, ojeda@kernel.org, boqun@kernel.org, 
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org, 
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu, 
	dakr@kernel.org, daniel.almeida@collabora.com, tamird@kernel.org, 
	acourbot@nvidia.com, work@onurozkan.dev, liam@infradead.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 740F54000A
X-Stat-Signature: 39ypw1y9rhgqgpsnumrb75cpbt19cpbo
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795528496-597189
X-HE-Meta: U2FsdGVkX18bWlU9Uh0WVb0b7bEa3f1U1NCi8OpLER3JnbiaBw+mhInHbzrhPOjFXwcNAUQUC7y5T2vRza+pe12mMSgaTWkQu5MDslEzoiqPBnnxG75C+8J51SZ6DHacMVxWykXtzhDnUC/lDxQIQ7LSPnLwGiNIZfrhOX/ztF6ieNNt3FtRSY/ubCBhvQSPvGXk5Yk8RnfV/NZsOOq7n3dONMDzjMXm6j3Yknh49WkykTLae95s8GwDpM040TES2XQ4I8tGZM7VSJgVpbuXeeKNgZaJG40Vu72eNga3370kbN5lRRf8mRCrjmR0bRTkPFZbUS4aEhcqAJnsFpXnpXDoYa01MUZdIH9cdccOPXT3g4goEE/PCrvWoz8HSLsf/LGiywDwyS7QzbxCJpxODi5hxCrUC26ltfA65g+i3LJxJ3WZS86uf0NbphwcRCtxizXYXy2AA6v6fDOrOxJAoVFHLVqSxe7Z2zrXMKPXIpE6yAtMYAf6vqF0w0CKK3sr2N5KS0Z+AvLmN/b3ugFqvcJJNMxGR3lSx8m2iJI9kfxMopiV00GOwz2BzmxSYJT4z5qoAU/lHA84TvoAwI2cJInL+UGY+bypGUVsPu79J1RZo+6h4CPNIzoBOUIy6uG0q1HTl7pk1YrFYzclM72TSjniu8jXo6IPAcAV9QFsRJyQ7LM8W2UvRdwhl/Ill70H3pJafR6jOFclUVCRRdlCnicLKdo73HfmmEFHdZbCRWOlEaMxLhrPmKbG02fUJuPKjTFQCTYlIiV3ECgZ+/Ui3P0cgxbgFnXeyAnc+bfbI7583S94ajf44wWy4UQGCruKOJjuKW2oN5kz2NUVzTqYdUXibWXwY6gO9RSYUO9qTY81dfQYkYmspOovShC2g4G/hQmC7UDQ3pgXmXrhExpmRSfr1l2bHTWI3Bqiot5XVdRUDvfz6/0p2Kp7klfyErq+1K01sWO/RVmlNcHVsis
 g2NW5aDj
 IEtqllNTEjcCsfx9WFVSuoFNPM7zcHoeH9wAx1LSnW2lDczAQs5sb9WswPPDMAwBF2hlY0xHvzmnRSWumYw98MlkyjW3gHWKNVh90c6QG+M/WgdDzhLU1l9AZm11MfqLkxEXvmHSon1x6GVoAKvcK+aibT7je8+ikPGh57jh0GgU+X+9KfIrSxcqeNdxMk+aeM3knHx7iy5jO8+HjXjaa/RZ3ah7OEYsI5r0XIUJ+bc7R833BFKQDTnHLpeYI/2nSlCoIz4T3pYwLDRG9HXNHu+Wqyun7+mt3fX30pA9AdSvCE+3H3ThX2mp9SEqsNVmcAtY8B2S9emQzzbPE1kGm4lucCykSLWV3FCGHzo+FQUgKS8x60VqZ8fpLGsgR0+o9FwrlWQoBscF34fbP7PhREX6vzxPaDoAb2s1+GoIK+lCz5HiPINkBJVHT+2NFkx6fK2rjXreZpFoTKAQxW4XGC1BQEDoNEZ5zTfQhd+/zosIS+Qyw4Z7YZ3d7xEF5YPVF/RcacBrFjyrf24qvdM5ZI2HOymEav24G4lZ6EC/sD7qtoZQyIfne++DbnZGScJUTdVWeuGfbNlQmHgon8QS6SzvkNyU9SnsBUhewgPi5kO+zEhJnkp84IKRYfGdRpHq/gjTjyFeuYC2u5xxfm1J9EBp+ObGXKh5vTkUYyyHQcXJfKo2wRYoYStb2zO8/nxRLs7N9tfS29SJoc6S6AAtxuo8Lvb0zq7ptFISxthImedGEJjdKmHQh3F1j7a9dg09RwVFoPbE3LIPwr71GMQkyWYqZD7bt86CiqvmwtM6awTWYbRXA+V8jYWesZWkAx8weyXq4X5oTObYJyJbh9QhQAieZOOrF85uYC/aoC6hPNoFweSNN3A07XOaGLCum3zBDybiNT9jLrUdnh4gJltYyvn0k3Ahq/efurEi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Fujita,
Thank you very much for the quick review and explanation!
Please go ahead and post your warn_on_once!() patch since it properly
handles all architectures including UML. I'll drop this patch and look
into updating Vma::zap_vma_range() using debug_assert!() +
pr_warn_once!() as Miguel suggested.
Best regards,
Ivan

=D0=B2=D1=82, 24 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 15:5=
1, FUJITA Tomonori <tomo@flapping.org>:
>
> On Tue, 24 Nov 2026 15:27:07 +0200
> Ivan Tverdokhleb <mbkchelofficialdev@gmail.com> wrote:
>
> > Add a Rust counterpart of the C WARN_ONCE() macro. It behaves like
> > warn_on!(), but additionally sets BUGFLAG_ONCE, so the warning is
> > reported only the first time a given call site triggers.
>
> C WARN_ONCE() takes a format string. This macro is the Rust version
> of WARN_ON_ONCE().
>
> > The macro returns the evaluated condition, like warn_on!(), so it can b=
e
> > used directly in an `if`.
> >
> > Use it in Vma::zap_vma_range() to report an invalid range, which
> > resolves the pending TODO there.
> >
> > On configurations where warn_flags!() ignores the flags (UML, ARM and
> > LoongArch), the macro behaves like warn_on!() and warns every time.
>
> C WARN_ON_ONCE() warns only once on these architectures too. I have a
> local warn_on_once!() patch that does the same on all architectures.
> I can post it if needed.
>
> Also, this patch does not build on UML, and test_warn_once fails on
> x86_64.
>
> > --- a/rust/kernel/mm/virt.rs
> > +++ b/rust/kernel/mm/virt.rs
> > @@ -115,8 +115,7 @@ pub fn end(&self) -> usize {
> >      #[inline]
> >      pub fn zap_vma_range(&self, address: usize, size: usize) {
> >          let (end, did_overflow) =3D address.overflowing_add(size);
> > -        if did_overflow || address < self.start() || self.end() < end =
{
> > -            // TODO: call WARN_ONCE once Rust version of it is added
> > +        if crate::warn_once!(did_overflow || address < self.start() ||=
 self.end() < end) {
>
> Miguel said that "Erroneous Behavior" cases like this should use
> debug_assert!() plus pr_warn_once!() [1]. Also, the C side uses
> VM_WARN_ON_ONCE() in __zap_vma_range(), which warns only with
> CONFIG_DEBUG_VM.
>
> [1] https://lore.kernel.org/rust-for-linux/CANiq72=3DtKVD13GD2Bzmt_LnC4Si=
OX1nkHQPcz2BS=3DP=3Db23e0Yw@mail.gmail.com/

