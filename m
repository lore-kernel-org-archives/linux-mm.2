Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F066ACD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3516B0092; Wed, 27 May 2026 08:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAED6B0099; Wed, 27 May 2026 08:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107A96B00A1; Wed, 27 May 2026 08:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3F3F6B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:30:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F831140420
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:30:50 +0000 (UTC)
X-FDA: 84813133860.24.809F9D2
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 959081C0016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:30:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="xuYR9/c6";
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779885048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/POtajBoUC3mFgumqgLA3FGG1S8oPKBOTiGe1Z230s=;
	b=m2bNZQl9ZqyEFbdKzSkzRBSWJSDtPHpPJrl+XnpD8+SvJoAHOKOHBSxYy1MKHD35Lt3Dyw
	S+1tG1qsmINmAvRRDanJMH+3MemjvlMNvdR5126fY5RcinuUrfGDij0PwEn2xqn4zZS2p0
	tTSM1twAEFXnPuF0vvDTjOUnZqFHdwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779885048; a=rsa-sha256;
	cv=none;
	b=tB8XYqfMedYq9U6dW1sHoZqOTYJqU7crJqPp+oCeLxjQbQgJOqKy1FiljgKpfK4w5utf0r
	R0A2nFsz44ZwRhZkDUL8VxIEnd2oBKapk9SLUUuBT/S84c6+2UMX9nMgGasn0lvxZT7OPz
	ci2iFCISGazHp6Y+XhqsfQylzUWEQNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="xuYR9/c6";
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id C17A9D0CF9;
	Wed, 27 May 2026 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779885047;
	bh=N/POtajBoUC3mFgumqgLA3FGG1S8oPKBOTiGe1Z230s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xuYR9/c6ST25csVo6ZStcfjbm+kUWzldNx2yWwJhOlAki++quTWs40fv4A5uToe5/
	 sQ+Uxj1uNRRueZcFHjPvRxTZgez4Nb8r1sVWOHrF9XjROTkbJLiNnYYFKdiDTFJS3I
	 8ElLpfpJtWX8Q6AxaVQUzxJA4rTYThRSdaGHfpqI=
Date: Wed, 27 May 2026 12:30:43 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <ahbj86sKJON-41GF@shell.ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
 <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
 <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 959081C0016
X-Stat-Signature: n19a9mne1cuyt5k1ch9ax85gs5456tj5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779885048-784424
X-HE-Meta: U2FsdGVkX1+J8Nb9qLU+hK+uDSPV2VmIqmPgVRS+JdyHL+RWGECwKIggxZaalcUqvyH6dCaE0YvEXgSWguJaI7zU11MSPrxFR/tbgHSleRx0PYONOZh0arHuo/54CG6VnABbRxxI1m9fJZT7AL8Un9n4DBMv5m1PGpYu9auIVv474leXMC46NGlUpbFuuvBXf9zBd74k6EySdIZV+bBoBRiL+v/sYYkcHmJPWn13w+ZZ1XOK4MeGirrPDtfQ8G0edkByxMdpBI7uuePnGT5nNyHsuWbLWjgRwW9H1sIZFoIQpoSd11VZnko0gS44BT0zVRSWMpbBizNeI1iSuIouwUSHY0x2OVvMWzBBXhJpmVC1jrQ8GwpQ/t9WYjqQIP351pnqBbuR4klji+aoIBr6RnGr1XlphO89x6y38ZsKpGyfoOYALjEs6IO7cMUMu9ikVSD4gzradEH8sJQ26oRRTuXu4O8WbseWXT62ky39ZaUFgVNQ7y1KgOxjtehbsYLb+kBuQBb/9ivxlx/0+GG1Fa0EEEmvs8VkuQ2c9Of2+tz4JlCf+drjKROy63LSXMQYCIY0fhICl5VipEm1t58Uq8RX2/LCdiTcHntS21CaH9B9UX0/WcEGikXsSPEPmbYUzxLfnIcAIPkTyRNdM2fPTmTQ+TCIozMasMFiq04R3UaO5hClTMFeA2nbgZJ5iFp/kedCSsvzHBoNYTKxcpviSn6lUAO2KRZrivV0sl70swEESUCH+q7aN9yKo/qSV3QpGky4BQbr8LBSDi3xUpuxW7RCf8YUNP+tPdggJpf23kpYi8a42/UJslQCYqYkDIkh/lwiJgBZotHafBQQjp5tCUO2T9C+NZinVIR7xh51ynBxeLk/kamdRgsuYqkg19vU3qQpbvLJtIYhwn20M1Qlv+jc+aHeNJLF7FUNhQmY4FTaHQC2rB6TU3ihRr593dNDl7yyfJU7RZakSY/A7KV
 o+3fK2xo
 UZDVHfhvNIoRGCS7s9piP/pNyPt9AUih3rMsv4QgkBQmCgQprWW8bhwBmiYPooYSw/KjpstSBYj0yc/HlLQ1PdXktvYleVi4Fw4gMF3PQgUtL1XQVO/2DNIruAtmnHBqdpYlcRS3Babi/faQAx1BsXgXIpvrDbXzIq4yNewRXGnCsQoP6AXx48KjG9ue8eohoICDKzz12gREZIMbDvjVCvxzQZKgVM3ZtTNbxneMFwk6xRNBaXj4oGM2vNsbf89pHSHZmF1MN3BRVY1RVMYShncr4CMPAQHsPsMEroeDOfavRPmKWagNlbcgAj51Oeppyl8/B34QRx+TAIlO+BGLcq1WzgfFC8HrP9Pv2tSGuj9GGFMz6xDXedo4axlbo5W6juxOPqzbWISgBvtVYRkmTg97DBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 07:54:16PM +0200, Miguel Ojeda wrote:
> On Tue, May 26, 2026 at 5:13 PM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > They usually don't collide, except for User Mode Linux builds, which
> > include both kernel and userspace headers.
> 
> :(
> 
> What about other similar names? i.e. a variation of your option 2,
> e.g. just `nonnull` (we also have others like that, i.e. no
> underscore, e.g. `noinline`), or `___nonnull` (triple underscore, but
> may be confusing), or a suffix/prefix letter, e.g. `__knonnull` (for
> kernel nonnull)...
> 
> i.e. it would be nice to have a "standard" spelling for ourselves, and
> also replace the existing `__attribute__((nonnull))`s we have
> elsewhere in the tree.

Yes, a different name might work as well. The main question is which
name to pick.

Plain nonnull() is a bit dangerous. It might collide with existing
identifiers (now or in the future) and is not great for a kernel-wide
macro. I think we got away with plain noinline, because it was there
forever. There are also at least 24 nonnull attribute usages in the
kernel that need to be converted atomically. This can be done, but it
increases the scope of the patchset, which I'd rather avoid.

___nonnull() with triple underscore might be a bit confusing, I agree.

__knonnull() might work. I like __nonnull_args() better: it gives the
reader a hint about the semantics, while __knonnull() is just a
collision-avoidance trick without conveying any additional meaning. That
being said, I can totally do __knonnull().

> 
> Cheers,
> Miguel

