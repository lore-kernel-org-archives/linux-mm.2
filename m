Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F77CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 04:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E941F8E0033; Sun, 17 Aug 2025 00:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AFE8E000A; Sun, 17 Aug 2025 00:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59C28E0033; Sun, 17 Aug 2025 00:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0DF08E000A
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 00:28:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7458140575
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:28:53 +0000 (UTC)
X-FDA: 83784968946.16.C2FB8F1
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0621740002
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:28:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FM5Q6fxd;
	spf=pass (imf07.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755404932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiJC33MJvOH1Vpmx9TcHijUmBr5sO/XAeGk2/N8gTkw=;
	b=6ALQx+UOjXeq1zB4s2Y2Cj0GSsgllgvXZaC4cCy2X5QLui8VQF2AxNzQcoOt1KlAJZvzf5
	Zmo7/vBUTwDPIEuczNsKEDKYcULAK8D0HJjZnb+H05tUCmxnymkR0VqIc6Cm6o0nYkB+BY
	7OmvJdrOoyop0NLhWHlyWbHacvvYkK4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FM5Q6fxd;
	spf=pass (imf07.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755404932; a=rsa-sha256;
	cv=none;
	b=sBmIzkxiJhUabu7jW+hcho0ROUNHK7mKAuuRMjJWescG2/HgHKPrnqAzH1CwVA3gK1EBgR
	/XX0ayInKLPsUmIfnIIJ8ReyGtDOlOCUaw/8a00aprwLwG+hdB6Lkz6g50ZJIlAJokEy+V
	wZXvwlipUu8LTbNMWlraTY2RHPDP08o=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9dc5c2f0eso2122163f8f.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 21:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755404930; x=1756009730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiJC33MJvOH1Vpmx9TcHijUmBr5sO/XAeGk2/N8gTkw=;
        b=FM5Q6fxd17SKVaT078Af2cR0Q3Mu/TFuIJfK4V1HftGBY+xrI3jUyj2nvcAeju6rpT
         jutIlTg+tfOZ88Kd5LIdNHLVpXknqQ3XD4xNFj31RT9gwZa9oTFb8tjnvXjj5bMv+ixj
         Y3xpO6j2XmCFKNoLiAH2om6pKKHsDIs6Qzz1jA7uqZG7p+HubDp4BDvM0WAd8m0Z8ydv
         oB40yKIgbUc7HLEcanB0NClmBZDPFzCoHuEQoEiGTbdg5UMy+PhPEIIsf7A0BwcgGB1z
         cSV/PkAX/9Bf8Y8Li1Q05cF80+1qErKc5fmDO7ezrynAKv2u6V7XUaSpvZbOC74qqGr0
         +4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755404930; x=1756009730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BiJC33MJvOH1Vpmx9TcHijUmBr5sO/XAeGk2/N8gTkw=;
        b=WtMjo0Htg0Wzm0ZQQInVPCtEeh0QaFbPJisTFhDkPfxP7ZNRAlDfn9zGsfrNsAaVmA
         tiKI9hJw4/DyLivFxBWDAgZPysAOF1FA+Ds4p/N713e1wWZ9VBYGPORWegtv7yehktlX
         1zxowYwJtY40AgsWW1IeMblNtNLjAk22hf1n9hnO/r1NzCubXg+U96IIv2GyVTLLSi2B
         b9IjcUh3OA0Bj5otqnL3OWx28fsEySKmpd1ZQMfcAB6cQtubuuk8GAHodm+Fiw47WmHp
         YddCYhfnVk0sQY3ibMrGIXesa2CtrrAcN5C4qLW0MjnyZrhuvvIqs1QxIh5uSlBSjofY
         rF5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxV6/vMwPu5zxVo9obAvyrca03dDz+IV+imwxAJi8M0hioBwS1MOlECvAPRqE+ny8ScfwaSVeFGA==@kvack.org
X-Gm-Message-State: AOJu0Yw0LYYsJgg414+PYi08aZcbWIRx3pR5ITiwtGke8nyr9Q6I3q8k
	aXDoq4AFi1GGRAj3Lz4FPr9m2+eu234kTKguaY3iqCG03Lbms1+GWFUOWRLJxxHwApgvt7vyq/Y
	KPA2i8U4yaCKUE+Gx02FqJJ5gvCYpat+dmpVECZub
X-Gm-Gg: ASbGnct8uXxghbLUMLCFeld2o6B/cAeiDaJbg7Qk9q1ga6vkvu1XiIY8UM2FDKsrkXb
	lq5EJ00dSz+CwrgAKzaEhcj+KcaVQzQaAa44/rSJt2Bt3a1cyB9OtfsJaABxTwPnZNt2cALo/KC
	nQ0kFTo5cqYqREGefT61gvQ8IooxKd3dXINQOX7upxmoelpK15fHjAAIqh9GZ1D4VHHkHN/aGtL
	fVAgHX5GpTMBpVJx9Yf15TwbrOT7M7X+1Za
X-Google-Smtp-Source: AGHT+IGS1pBzG3LJi4LJWdLgnoIui/QvinF2gyEaQMWHssnXGuqeTADFCMUiB+RW5hDg9XSqK51zw3Dazhk17SzXGFw=
X-Received: by 2002:a05:6000:400b:b0:3b7:8914:cd94 with SMTP id
 ffacd0b85a97d-3bc6aa272c6mr3281632f8f.41.1755404928970; Sat, 16 Aug 2025
 21:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250815225259.3012455-2-sudarsanm@google.com> <aKA7180s0HdLfOKc@harry>
 <CAA9mObAiQbAYvzhW---VoqDA6Zsb152p5ePMvbco0xgwyvaB2Q@mail.gmail.com>
 <498fc518-d78a-43a4-9196-507891e9b844@suse.cz> <22666e86-2523-4136-94e6-0de126fcec1e@suse.cz>
In-Reply-To: <22666e86-2523-4136-94e6-0de126fcec1e@suse.cz>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Sat, 16 Aug 2025 21:28:12 -0700
X-Gm-Features: Ac12FXw1MXLMOdAVkoTs0tVE-q5mUXa0vf_noCRKGgACEIZjA3myKp54MhzQnoA
Message-ID: <CAA9mObALY3L=G3Ti52pSnWYGHspDa01Xr6NeiWHwTGOX76K7nw@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Liam.Howlett@oracle.com, cl@gentwo.org, 
	howlett@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com, 
	Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0621740002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nzpmd771zjhp74pg69g9okbzzwp59gfb
X-HE-Tag: 1755404931-952875
X-HE-Meta: U2FsdGVkX1+WEknCCjC/FRlFstdHmIcHEYGmTnnmzf1kf4gCe4D5ShBxXSIyvgLEJTs0Eh105qeMtz7NrlrpfMT+jEmNUHeYlA4khV0jfH/JgetHHpXcEfQB2mOvfDRMSlH2FQibim16rUm1kC2zUDawFlXGMCagy+4/3lXa5zo2k04wVgV4S8uklIrcN0CDLsTQ5AEZkr77DAuovjEX5MEu49leenX88aA/tM7U1cUuvMEBFSStIHpWAKDVYusy2Q7Z2+C54W+RxZjSlfWllElcBx/RucJoOkwIO5uNixl6T3Bm0/VL9fu6IkBeU7QtVyzZ6xr3YrQrQFt9UtJrdL5ZN+YHdj0KYp4uIQHWQj11IJCGiNflybltoqqmSMPMguJRPLJ3ZGmtQ819VCgU2gB/uB109854XM1wDhFtS/B1ctxKqUbrLRqCJKs8MKdxgbV/3r6JlduM/WbLvsBSxB/yghXZR2+5Yye6rVJAiW3+1oi5+47XzLFkA3dsnkt0NMmAA7LhSjqTPSzs5n2TNmaP48U5IB0XfCf+zbIc+e/+i1DKwQheRNAniSLIcA1OxNMOoeXVUe7pmhlgdLtkwKalYTSk2e7shdkIyNTaOZG011IZg7fh/zu9IWMG7pG9Prj2M9phD/hmXMOFKeWCjXIKqBN2LgWZdBkhDfewP2u7mH3zoSSAz8rnYEX/v7Qq9+xRFxtDzd9qiMRoecneczOIuzDYA4pFP9vkxLnKi99Q/M+l9T5dR78wO3f8nkXMcP3dUI/TGzJiAjsJ4cwgLBdYtpf6oPDnGRh2nKR+dEGUeJhO4RL4DpJRxiwoAOjiX08WKe+tXYYTYMoFEW7bDM4LQh9M/cOL/JB6zMvUDGMhbmJJRfiD9oEm2lNoMQIjjY6Bqd9hu/y2V4XB/Q/Iq/jyMiL/IWQtIYvHzNvx2+IrOJxWy41OuUPy5u05Vgt23l7e+EkPco8Pt+fNzF0
 VOQdt3Fl
 7YX8v4qxho7dcZQ06MEg4IGjLJPgGXyilh33dz3R8cxB2/VTgFL+J/uEQ2b3q4cmfiqznByFKOt4glQMiDJKg266gD3L6dUCmnS0LexRTU01kPSp9rBiLVRYWw9T1lDz6btZw+Ddv+KPLaxgT/zMijgmiai7yCGanzc3vNmH2XrEMK/7HPlBTW4twsV97k7QEMRsgfQJDOmThkBq/DWhA1bHa+vBRozzILPcG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 11:31=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 8/16/25 8:31 PM, Vlastimil Babka wrote:
> >>
> >> I assume somehow the free_to_pcs_bulk() fallback case is taken, thus
> >> calling __kmem_cache_free_bulk(), which calls free_to_pcs_bulk() ad na=
useam.
> > Could it be a rebase gone wrong? Mine to 6.17-rc1 is here (but untested=
)

Yes Vlastimil,

You're right. It is a rebase gone wrong. Thanks for catching this.

I ported this patch series on top of v6.17-rc1 using b4 cmd

b4 am -o - 20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz | git
am --reject

For some reason b4 merging yielded me this:

git show 893ee67b5c75e7411e4e3c6ddaa8d0765985423e
slab: add opt-in caching layer of percpu sheaves

@@ -5252,6 +6133,15 @@ static void __kmem_cache_free_bulk(struct
kmem_cache *s, size_t size, void **p)
        if (!size)
                return;

+       /*
+        * freeing to sheaves is so incompatible with the detached freelist=
 so
+        * once we go that way, we have to do everything differently
+        */
+       if (s && s->cpu_sheaves) {
+               free_to_pcs_bulk(s, size, p);
+               return;
+       }
+
        do {


Whereas the original patch [1] had this instead:

@@ -5033,6 +5801,15 @@ void kmem_cache_free_bulk(struct kmem_cache *s,
size_t size, void **p)
  if (!size)
  return;

+ /*
+ * freeing to sheaves is so incompatible with the detached freelist so
+ * once we go that way, we have to do everything differently
+ */
+ if (s && s->cpu_sheaves) {
+ free_to_pcs_bulk(s, size, p);
+ return;
+ }
+

I have no idea why b4 got confused between kmem_cache_free_bulk() and
__kmem_cache_free_bulk().

After I fixed this issue, I'm able to boot the kernel successfully.

[1] https://lore.kernel.org/all/20250214-slub-percpu-caches-v2-1-88592ee096=
6a@suse.cz/

> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/
>
> This branch specifically
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=
=3Db4/slub-percpu-sheaves

