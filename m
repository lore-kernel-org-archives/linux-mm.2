Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B41CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465426B00B6; Wed, 27 May 2026 12:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E8B6B00B8; Wed, 27 May 2026 12:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379806B00BB; Wed, 27 May 2026 12:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28A466B00B6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:23:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF3081A0655
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:23:42 +0000 (UTC)
X-FDA: 84813720684.17.32A1B97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 48CCE1C0006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:23:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ium4RJoh;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779899021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fjHk22xqi35uz8KDrNOCGFG2idycCs1iTRro0+9cA8=;
	b=I8o5ozTpS14P5lrOyk+0mrY5QMB28bt2HNSA8WxJC61CwUmjnNQOR7evkVrfUi/nai/EkR
	lwTiqAFClr9/u+g/HgNuGOj3wDJW9318e2poQPgX0L7w1RcMZsheqRc+/IBWzOPyWkJFd4
	1p6PKHP13W1ikI6MXYOUvQklZDs5/uc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ium4RJoh;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779899021; a=rsa-sha256;
	cv=none;
	b=rCGuEOe4tT0cgZyqQYGtwKcRROu7WTx+roTF317m9cPwjpA1hR8UDufigWZQ+U0JEST4rw
	8tfWnp/FmLDAkughLX5d/UbL+1K3Oou8IBC/inkmGgtdND9pXI3SHIal4ObVBgGbrumjvL
	SoCDowEoWxqbY1/uSm8xNIUCD6t86x4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 466E04364A;
	Wed, 27 May 2026 16:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E394E1F000E9;
	Wed, 27 May 2026 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779899020;
	bh=2fjHk22xqi35uz8KDrNOCGFG2idycCs1iTRro0+9cA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ium4RJohFQpVVzJBfFdSMT8am35jCMhIy8CaKvFwIEqV0X3F9REdbNHs5r8329kWW
	 r7HTAMY47kROuwO+1w+9VuQNJ6b2/0fHQEnKhFLwGdA6KEC3t+1djDsdq6vy4+4EoC
	 +ZmFXueXXmOk/PtV3xMFD6LpNsYprUhS+asr9+eIMWY8Ry8oz0YtMsx1yvF82xfDBs
	 LkjYHh43Gl5k9hM96+RuygpWjpd8kXLrjIAeUDX556xNKM63M5SoBtB4pxuVKV4Q/x
	 kCk4p8ciWvdL3s0oAzIJu0AUE8Vwa7lznlfNmYQlN4OFpfxVlIs7xnrKBWxo2j96M4
	 ZEJ6N0yf402pw==
Date: Wed, 27 May 2026 17:23:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chris Gellermann <christian.gellermann@codasip.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, brauner@kernel.org, 
	shuah@kernel.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftest: Fix UB of getline due to missing var init
Message-ID: <ahcaVoRh_Ona6EWm@lucifer>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
 <20260526113409.ea65314eb1da831de7c90ca6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526113409.ea65314eb1da831de7c90ca6@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48CCE1C0006
X-Stat-Signature: n5cgihxy4g8paw6kch1xf8xku59zex1d
X-HE-Tag: 1779899021-597631
X-HE-Meta: U2FsdGVkX1+PCMV0+RfkJQ1H47t+gtY4G7zsFmAfw+N2+cml9Cf2AHQNIVo2fvY1lrPeJuIx8bp67sokZBuG/ouGkCkVuxK9mXlF9rkGFPiqo3RQkAZv7Obkl47SSRSpz9q8I9T9zpLTB/cL8+xkFi0xV0bv1usIm4G9lRyYBACup4I0Acy7hc/AAdH02QrFXR1ftgo0TdyPXvitzrKiO6Oo/DPdi1hlB/SffdTWi/yRCt8HR+DHsK0Kci/yKDpMUqt7fJJmqpwO0XzratvfsByMXCCAhe/CtxfTK+HlM1CGyuYatLotLXYYI2OmnLmcZS3ZBeadDVQO4d0u0CJBmEvDPU2M0dYrk8Tu/0EsTppJUCtWf3AaxGI2yGtE4zvgiOwSD26jln3QEgsmBxCO9bJr9F+v+bZ1Hpsqa81v/CzuTiZs+YFTE+U5WVcsx78wiWSrYRVeELTq0HDqxMKNhvSnoS/8bOmHzdUvp4tuZOsnVQhAFtgf9dt55sME+BBI/DJgHDh7ATecWcTGgsUVZT20sJDYykwlDthOdBo94LoXysDQIgCagpM15YJp05MI4375v9oB9c/oSV4JRL23fEeSyBaF7jcQ0v0qeR13dX8HYIQ0zER7UeTj8eNTSuk2nXgpCX/wxk7HcM/tc1ktzQc6ayd22QFkYiODApk0B7T/U6Ys9FGZ4toSB7Pv1zdta/Gnz0OqLwValxjFS/ieGUTKvSzLvfjnvfVsiWAqVCZMWiekXdeNUAvpx1d+NMEmiqPy5N7kxXNgCsEWj25c1moeIR/QHyB/J6VsNXPyXsXLx7wtjLbs+5VAh3lf4EmKH57apfQ/czuNX2YPji5nNqdjYXaSqaUfkAIkm8LB4CvPDmF3LRGbeVaq/mxtVVaD9pESM5fV9NWsodXTBlZyHwMZ6h7uP9y+JHS5oB/Hc4MEYb8cnI6gvslGkMdwhewbk60ZgXyTmJsGXbenaYn
 eL/zDiWp
 HZq+lUT+OWqv4zgvWsUhRXd5dWLKQIJ0zLdhW7rr6oEB+AbsonYtqQoTKhc3xxfCYe4SGIA6xoS0Mb8F1CbVcNQt30Rz2Sr+N+Ku/iuMQ36Inc/Qya17dUvUt3DH+QVz7VCnxvgpOxj77ze971ZQh4ZzRWbWzPwHzHfBlaM/pWJIOBZT7OnOuzFlc3Q556vgMjaJIH0jiLMURLblYgPkVZMtlZT5TfowgOw+jRNHEx1HZ6f16h5+7TJbJYyP3N1v4LRw/RybyhdxjgDXrVKKwqEmq2oUj+uARcmbaFE+xheQ5A/vXL0evoIA09GPEHo27Uwe6bcphLHUdMVRQxhUf5qsZW2Goh/Gy80JCW96M0/PBex53u8/hGwG8GCI+7lURSS/MQR54ge2SZhoGU6z3hXf0zz+WlV+dZ92t9XSsU4FCbpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:34:09AM -0700, Andrew Morton wrote:
> On Tue, 26 May 2026 13:38:48 +0200 Chris Gellermann <christian.gellermann@codasip.com> wrote:
>
> > Subject: [PATCH] selftest: Fix UB of getline due to missing var init
>
> hm, what's "UB".  Please expand the acronym.
>
> > Clone3_set_tid uses getline(&line, &len, f) in a loop to read the
> > child's process status. The code expects that getline allocates the
> > buffer for the line on the first loop iteration. For this, glibc[1]
> > requires char *line to be set to NULL:
> >
> > > ssize_t getline(char **restrict lineptr, ...)
> > > If *lineptr is set to NULL before the call, then getline() will
> > > allocate a buffer for storing the line.
> >
> > However, char *line is only declared, leading to an undefined
> > initialization value. Fix this by properly initializing it to NULL.
>
> Does the test crash?  If not, how come?  Luck?
>
> > Same issue fixed in mlock-random-test.
> >
> > [1] https://man7.org/linux/man-pages/man3/getline.3.html
>
> The two affected files are testing significantly different parts of the
> kernel.
>
> > Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
> > Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
>
> And these were separated by three years.
>
> So can you please split this into a two-patch series?  And I suggest
> you add "Cc: <stable@vger.kernel.org>" to each one.  Please retain David's
> ack on both.

Since this looks fine (I also wondered about the fixes too of course), feel free
to add my tag to this too:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

>
> Thanks.

Cheers, Lorenzo

