Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44304CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EF16B0088; Fri, 19 Jun 2026 15:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0664B6B008A; Fri, 19 Jun 2026 15:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC05D6B008C; Fri, 19 Jun 2026 15:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C299D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:33:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29BD640509
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:33:58 +0000 (UTC)
X-FDA: 84897662556.26.D45CE7B
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2255F180005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:33:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ulu666io;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UixWekKQ1E/9s6EcbfIpsM1Q9ZWGO+u8pFvuLswEpPA=;
	b=osxjugP7nkux+LVnvWR2QR5ofNTrJ/YcxOHc3WaiyXl//zi4fPHfBolkO4I0+MIThjo23F
	nydD9wIe58GjIWN0EVdhY7m4brM8i7g/ccxq/fGGKZ9Qig/cCS6RaVFgm2rPP3PIjJ/uLX
	OP1pfFgF1+pE4lL/RdmY9EAqf81J/aU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ulu666io;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781897636;
	b=PAgFZYgE2WKWUJCTpnHLRMlZ2o2P++V1x0exbCQNyqyi+Mn16Ak2406sdrn232GPXq5zIL
	mmfgQ7NhTxCCNFsHZ3rkEh2oZGxjSKX19t0RswM9XbTio1qKVaPPjWoXkmvfKmKtVLal6E
	pF09lsur7wm0mv0vwN0lp4VRjOoSKcA=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765531803so372241cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781897635; cv=none;
        d=google.com; s=arc-20260327;
        b=PLmKOTxGg13jxVR24jGV+kKY680ZmUy5awHK+SXSMSlKj3BKxcTNjQl4/s2lI8xL8q
         e0xL1sf0PhqZD1OBHI1GeUMkoAso2rhXQ+caRwnoWYRxl+X1N8NbAFUZu7MbN0KCvOOq
         cX/TGpjyOVUXYOFRWGZW0LfPc/bLa9WLbwoX/jsNwl9wHHYGns3BDz3PwkUV2MxmukVA
         F2okWNEYfbTsbZTxaHlXXlaWdxVrp8mK210LuASQ8SjbPfjYchXXJFtO1llOfZYXnppq
         P9GFgII2nvXa5nwIAZtzHEw8uC6ZB/P3pNRxxocbM6scnBUZlkhUsm2ScfLpi2bs9RS1
         JEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UixWekKQ1E/9s6EcbfIpsM1Q9ZWGO+u8pFvuLswEpPA=;
        fh=i58PYqpVrjEuf6SAno9Qum5y3GoZo28qEmDsGS46NWw=;
        b=WZT7bJwHVXZ8YKxMosaJV1cECXYqc7gVrUMejXOS/2ca3Md/1IRiTbOBBwlxNkbeLL
         NUaeeJTOtu+E9EpMJvhkFLiH1jKAPVW/Sa3UOjTpdRtMWuwiyzPM0f3MEW1lJgMK2aVL
         FSi/y3bzZcBO+zvEAj87COLCxdlQk5/qp6Jf+EXtKAutq9GSiHGIK5HfCLx3yLMInLup
         eZJ5Q1/vupR2c/MfxaAerrBw/4OvATqY3h4jcK000Gyy/59aGux7NwDQkmjuD8u/W5yB
         8rHMv+QpA5dG7D04oEAX9Hk0SAiuaAHVCQ5AqmuqfDEJx4k8D6i6ME1zu074wqbks3jK
         okrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781897635; x=1782502435; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UixWekKQ1E/9s6EcbfIpsM1Q9ZWGO+u8pFvuLswEpPA=;
        b=ulu666ioKv1QxWXKHHeMTSsUWfeIhtB8E+KlBgZMpwO4BTi4FoKiqduLxscGjWfu/I
         4GgPUJGVkRKKsLpTp/OO1cSNaCMDGfA7yDyqhrzr13s3SGfnsRdOgxsXUSiIoy6Pcr61
         SOgbDvlIyOogET+XE46kwp+qt2UJujRyD8tcAH6ngvZ+R8l4CfxJqpe0tGX+iP56bHLl
         xfgrtjti/BoWYdURE3cUro5fbHoJJcI6YJl0DxSfalllHgvcZyp5WSezbJ+IClfEQryk
         u6eKORLLNWDjFmLPxWX0UAOFmtZITsJ3E3EfjlOI7eJwvOXtM0Blys4+9Cf73PJzcYal
         c1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781897635; x=1782502435;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UixWekKQ1E/9s6EcbfIpsM1Q9ZWGO+u8pFvuLswEpPA=;
        b=gcDNR1IwlYLbLgdmNou7tH9TAsf9KfEAJkeTMkDrFyv4Y/3GLH6MgQ+f+91A5O5xG5
         uTfv95p1+Oxot7zOvPNqO9WKjD/Lg2NDqK/ElVlOZALWInMyjfF2ezREkQoeMmlfLVqW
         8j+nH6ayjiqQIg6jPoReD3Ao0N1R7SqgLMR4utZTT+1KL99kSQx6Yf2jk0mWCthNE0tq
         qd1xMDS/zjHFMJgGl+nDE85NylwAeqOB1ekzpfeL+VMrBBa4xePtfdC222uoqDtto3Pk
         9Hwvb66PfgqozLIY4ceLCoNMYzPdG2Z9YzyCxFnQzjtASh1jRCa/Oc9W7J1Tx8wDlHoT
         Ys+g==
X-Forwarded-Encrypted: i=1; AFNElJ8JwAmcfo9hJb6iA+xpAv1P4dF9UuBpAjOpjF5tQlFTADYl7oGB9gIuR5dJqD7moL51GzxFaLuXbw==@kvack.org
X-Gm-Message-State: AOJu0Yx4E989yujC3YNMe5stT+9bruZ4CtnJtCRTaWJNRiQFtwSGJGny
	ggQrPzG98GYgGFEtnH38HJHXudPIdFK6g+qSNSdHRZbngHwnfsON/eIFVzB+HnUdvphC+/GbJnF
	oVMIXNhVn73rY4JlZ2K5kqf1UC4gw8P7HamFDjzO1
X-Gm-Gg: AfdE7cneqkZDFlPiKzGDYx7QwD2+PwxLFnJp72buazwVWzggjUQivuE1Ia9uDLBXEwo
	zDIVK52noZHaYrdVzhfzUuheA0oEtScNMM1R13Oc2MAHfLB5Nzl79LVKwlp/eMj1MZijcnC1Efg
	YErdLhnuzyis+R9453EDuovJKYar96h7RUA4r6pP2IuiBoGk01ieAgxlmBKfHOF9DQzoYf8fpld
	fuOwO1H889Rtxa/vp+zPH70HPLGW6jWKQJgplqw3NE36vA6EycXBNO0xnkJyOq2f9Ffmco=
X-Received: by 2002:a05:622a:4183:b0:517:5ec3:b59c with SMTP id
 d75a77b69052e-519e489116cmr11379961cf.2.1781897634481; Fri, 19 Jun 2026
 12:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260619112852.104213-1-ljs@kernel.org> <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org> <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse> <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org> <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan>
In-Reply-To: <ajWXEn7gECvgG7F5@pedro-suse.lan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 12:33:43 -0700
X-Gm-Features: AVVi8CcQdg_GeSS44UmY6f04HdsYstBTwAOA63kTc6IMW2JgtuBGnEWqPtwabq0
Message-ID: <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2255F180005
X-Stat-Signature: wm3eumsothffgz71he96funp5iiqbinh
X-Rspam-User: 
X-HE-Tag: 1781897635-125529
X-HE-Meta: U2FsdGVkX18RGiEx3HYLR2aGya+rDRFb3DW9Zo57tihwV4b6grWWuRMF5t8hxurP/tgRfyigxIHDraNjIdqSPtGG5kKv3yvNbva+upc45hnAu9YvOKoEvVxmJWfSrBbOYYCy9KSfpGiUC4Fi3F5G3SVFnsFSAmJQsrl8XonY0kG7i7/OBhDu/eSkl3OqAdNOjdu4c9aDO1u46gKDhJdZheJ7DEH7eEzkkEsPbSWLltIEm322Jq32LjNSjco5+vMDiZvESbfDhH7Mxl/WnIEOpD9kVBjgwxy2iBjwr/QKMli4lEtVLB74UKBCZQjwXY49Dvx3MEJKsUjxbkM5X1hWwz+pLxD1BPElMqP2exPXCMWuVk474puJyOcOw/y1sKEUxJQqwf5qMpT0EEAKaCP5GplDkiMLkqpLadKy4i35njTpJDdzIv2y8OvkTYnDOs/mIPBZ0c/CLfbkF2op92764AJq+YFSWOUJPU45ZEwHwnMN+G/gE/UiLuVP915aluQjdUhkvcNHgVownCzDglwVsZwybnxH6Lfl0SBd8c4Xf281JC2u5AGoW+JfcIBIi52sZm3ePQRTeeARzM6P0A3v6yBj2pJ3+CAnoUJMu3tSUXj0Cj6QM9CN/YwYZsLHgkTPx93x/7L6hnSrI6rbinxorKmCw6Q3hmszt+bTr0ZqzBErpj+yqawEKZLGCKIu/7m7D/il90VnlaO3sTFbypdf/eYmxLGPWyn+jIZ/em/Y0ojE0ceCq3vQOm4nztzq/H0k3MSFf0V3+6Md/bbbUlSNs8FZpcqWei7p4nODR3OrXkPealI+lCM7UjnTVnik18KTz//BnZL2fXIznwn6V0RSDQhBvcAnzVOh4Ntuol6q24lF5hNevSZQzr75RsJPNdh41bc4r7NFreGmEprlRlXFqlWANVDs7PS+wuSh8KKtlG6ZWSxQJaVzTIiTqFzR1C9iFW9kyIwiPlSBdJN/RTe
 iQjDx27R
 RN2ZpyW5oqxkqugC4t+fzOxp90o+2kx/AxmQgZ+cKLn6WLtHLeNcfNCWHqB322Tsp//Lz11QkSfjXU+uxtU8VXUZQWJ4hrKbaxf9VrGn7E6TyIW6x4qJMGppY2m+1ZWv5nxyNmyLXfAAPlF6whFXUu+ok6zNZv35d+0nfyMZiRW4P7Tg8WIC5BQOp04p1yYBOPKEHhZBNCrLsWtqZhdS53LQgQxcfUCY/mGpsf86nfgWWb5+ieKLAH8mjFr0XuBjgAjF/OdC9Y+Z7xmxE80G03b6eMvB8Egf8DXs3dVY5aNlyfgbDG1Hb7Lp4OJHzuLwBiJ5H6kOB66DBLMbYNs+pmftN7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:26=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> On Fri, Jun 19, 2026 at 10:52:07AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Jun 19, 2026 at 10:46=E2=80=AFAM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > > > > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I gue=
ss the
> > > > > pattern may come up time and time again for people doing chunked =
mmap
> > > > > reads. I think we need to take a closer look at this change.
> > > >
> > > > Frame-by-frame mmapping for a streaming workoad is quite questionab=
le
> > > > IMHO and I don't think we should be optimizing or encouraging such
> > > > usage, but I understand the reasoning for the revert.
> > >
> > > If userspace is properly tuned, it doesn't need automatic readahead
> > > at all; it can disable it and issue manual readaheads.  The point of
> > > automatic readahead is to cope with userspace which is doing stupid
> > > things like calling read() for a single byte at a time.
> > >
> > > Could it have better defaults?  Maybe!  It's worth a try.  But those
> > > attempts need to have a very low bar for reversion when it turns out
> > > they affect other workloads.
> >
> > That what I meant in the last part of my reply :)
> >
> > But in general, I think that benchmark measuring "how many frames per
> > second a CPU can encode" should be revised so it doesn't depend on
> > file prefetching mechanisms. Otherwise it's measuring something else.
>
> To be clear, that's not (necessarily) a benchmark, the code we were
> looking at is their encoder app.

Ack.

>
> (it's also generally not possible to prefetch the whole thing into RAM
> because, well, raw video files are quite large)

For such streaminig workload I think read() would be more appropriate,
and the change limiting read-ahead by VMA size would not affect it.

>
> --
> Pedro

