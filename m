Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38245606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=A9KLBjkV
Received: by kanga.kvack.org (Postfix)
	id 64FAE6B05BB; Thu, 29 Oct 2026 11:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D576B05BC; Thu, 29 Oct 2026 11:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D656B05BD; Thu, 29 Oct 2026 11:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36E7E6B05BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:50:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D901B1C3C30
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:50:52 +0000 (UTC)
X-FDA: 85376101944.03.D5248A0
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf02.hostedemail.com (Postfix) with ESMTP id D484080002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:50:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=A9KLBjkV;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf02.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793289051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGVbAria0Qqiedh4pyoA4PlNAYwcnbIuCp+A1N8+bTI=;
	b=DtdjIKwcNd0zecGd4dj9NS0ZlN96BhXMGi4rwKWfN/BoTrr1kMVXTV+wnNLYxZi0LEoy5U
	87wgwf/lUuQjYilRJ02Wg40R4ZL1Yt9H4YiksH2cGxPGDDF0ooy0+A1NdqqXSdjp9lq66g
	53B2V8gooKuyFBqtHwJcH9dC0woJpZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=A9KLBjkV;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf02.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793289051;
	b=eCYAwC7SSmEs1PnGyaozMk+e/ng6Wfe3aUNjZ+GmJn721i702pyw1R9M4R7/fwtVuHGIs7
	ollReZuR9+85v/fhh13rt9IXDz+AAN1QegIc2IAArIa+mfzqVLlmlSB1eG4jULrpqgLkBG
	tAVGVri3VOLwOofm7l1dJ1sMHmg2i4c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZGVbAria0Qqiedh4pyoA4PlNAYwcnbIuCp+A1N8+bTI=; t=1793289050; x=1794153050; 
	b=A9KLBjkVV18JvImOKBqQB4Zr5RiiS3EpmLVZC7L96H6rdgFoF6ORnrnx7BM1RpgrYNogC7P+tlx
	cXMeA48etVLIEKea+R4MOVnCXb5nNhVINSRORopBIgfoj0Bu8C82KHb3ej4mS8sE/obVhuvHFpES1
	Gri4Gh67sV5NMBUnCmJb4AmMebODLHPFqNMM6yxEuyNK7Wq4KJ1D2x4GgPJs+nVpvu0irs22M2woj
	7fdPdOuiSSDvkwuoTzmhUAbpBv4bxjPe0qemM8f9Uo7HQhnhRUuVtj/YZ3L8zuph40gfReF0DaVki
	QRGrAqQmm+pgeMIy6Zi2rvFBlHrV6E/LNsGA==;
Received: from mail-dl1-f47.google.com ([74.125.82.47])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xMSOw-004ZUd-0X
	for linux-mm@kvack.org;
	Thu, 29 Oct 2026 11:50:50 -0400
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a8cc11ac42so912294c88.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:50:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz2O0CCT1i3WPIaUl9bQLotYwR028ZL6xavKEiJw727sHE6IVR/i9dyjriKqZOANBa2af2MUsANaw==@kvack.org
X-Gm-Message-State: AFq9FYJhieyh8bCqU7rk+Et2EhkehK5iwEV8aVX3rw6IfCf+W2bD5Mku
	45z2SvsGjPMSux8zSnkX/BR9TKpAIkvOIevLGbtJHn8fLx75d+utVL/+Q1HDS8lEYB3GLqZVbPS
	UmKyD3L3J2Wel6mtJSUENXDgw6inRuiY=
X-Received: by 2002:a05:7022:4396:b0:15c:20b8:796e with SMTP id
 a92af1059eb24-1a6ce208ad1mr9947732c88.22.1793289049038; Thu, 29 Oct 2026
 08:50:49 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <attzI4sj2Pagmvkd@casper.infradead.org> <20261027192014.844878-1-nickolai@csail.mit.edu>
 <auNdNjH4zo7OYbe-@gremlin>
In-Reply-To: <auNdNjH4zo7OYbe-@gremlin>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Thu, 29 Oct 2026 11:50:37 -0400
X-Gmail-Original-Message-ID: <CADGQE7EtDGs=g7p5=_m2LieLcEj-k4LyupOFWt96Aw9py-gYaw@mail.gmail.com>
X-Gm-Features: AclHuK8yS5TxpZVU_n3PpHxl-8IBYZs67giAAwk7Tv4-zhBVnjxpmpu0FOC9ZHE
Message-ID: <CADGQE7EtDGs=g7p5=_m2LieLcEj-k4LyupOFWt96Aw9py-gYaw@mail.gmail.com>
Subject: Re: [PATCH v2] xarray: clear the new head's parent before freeing the
 old head
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D484080002
X-Stat-Signature: aqymwwa3mpkwzzkdk8ync4q5jfm1j4ux
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793289050-917971
X-HE-Meta: U2FsdGVkX1+5GqILXxCHac92uTNuPeNxD5jkete7KfTVa8tsbzK5JUZph6TZIuI0aagYnBrYxNZx0Dz54EC/llSdy/lfK/FqooNm2V00a/U9wyiIociN/F0+04uNTy+Y8fpKIcx/zcl111qLk1WKqUswvHNWy6le7dl75iJKR/4Qpy+sbrvHdogF1ST+wEZ9EwB9h/m7tvMsNNqXdvUhw63fBhpoV88r06DMbHlYI2Tdsdvd4fHLYYEHdsG3DTEo5YP3vAFbcAPhG3lL2rxKhUimYK5ncMSbV8kbAaQDWzj0tpGffTgdxZgGSXmYNdryz/JQV+3Q8uQOBpXb6RLF2ddLxlwTQesq7pgXMfqWVHswyEEmUDI9nqPJlyEukbjITJFQ89jl0GnEoLgVx8FTQk30UOqCH6Gg1yN0xGG4NDudyh8eSSP4Wn/3RGeK1DEpMcOninpK9srRC3AYeDzEBD4AThMhuXOIA7nXgV4w0WV6OBdR+E+DcDmwAKsqBThA9ZkBwH3d/HoyFWAM1TPj9YLcUIhDVdQDjZgLjtUG3nf5Oczmw9npn7WETD9DbOyK1G0idz1idID3TotWLRQpvdaBIdyPScAxPLzwIylFdTAc8OYA3xqyf3VusfGUYJIPLifpitMjLN1VoUBeE7KxxVRDxgs5BWrbEDI98KnK4ae0cq7lFPJ78qN9+o9mY+sYARX82q+H5EvFRJGxehoFBwRLEw/EYoYi6quo+S+w3fpZicAVuHRMpToRynWmeWacgVt7nO7aLicrzab9InIfSgQq5ooEChJS5wPadmqKU+YoQGd01a3IVN3YD5xJRM/8FnnlEi6DzDYHW79Nlinc0BaWOUytd5UWAs99C6bgt4rT70rmVb1/5jeYIuRmdL8Ie6UfFdIVZ/g36oKssPpq3/x93GnORFaTWgXN+1xOGAbs+QYCcOVQRhcRIHzlHZywIoYmoxKetspQSBfgkU5
 XXz8HzHo
 Ti7tBl4RY0cXCCZDpHP2CQaD/xy2bri1bVBixWb44HDQdOn4hP3W1ynVlPa6U3vCsdSSCArvqIpMxpol4t1oZsxrAUVYFYk3p0j9eemLL9fn8OGygfTbDFYWPsXJgrNfDGvE5adO4bY6PyTjfBcvs3BxY7kGSSNalEFbhjyyD1gi0H+bWFpjYaswYpmvxlZM1MkGG0bepaX8wHXuvWkzPmH+NBfDZFvTDoOF1vw/UpY1GBw0w+ceFAKEFRIcPDXTNA4hZvmn2k5aaw48J8tK5Jwx/0+EfuEhT8mH9ShAbdoWkv0bgBVlph4k7ni8mznYq1lal
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

On Thu, Oct 29, 2026 at 11:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
> It's pretty 101, but please don't send new revisions in-reply-to older
> revisions or feedback [0].

Understood, will do.  (I was thinking that applied more to
multi-series patches, which indeed gets unwieldy.)

> Also, if somebody replies to you, reply back. You, not your LLM.

Indeed, I've been replying personally, though in a few cases I sent
the response in the notes of the v2 patch, in an attempt to send less
mail to lkml.

For context, I use an LLM to write Lean proofs of correctness, which
seems useful for cases where the patch is non-trivial (e.g., [2]).

> Also, you are flooding the kernel with patches, 5 series across 5
> subsystems over 2 hrs:
>
> https://lore.kernel.org/all/?q=3Df%3Anickolai%40csail.mit.edu
>
> I already asked you once to stop doing this [1]. You've carried on.
> [...]
> I'm sure you're acting in good faith, so can I please ask you to engage
> with maintainers instead of ignoring us and treating our time as valueles=
s?

Sorry about that.  I'm happy to send bug reports with clear userspace
reproducers, instead of patches, for any bugs that seem particularly
significant.  I'll also get in touch with the relevant maintainers to
see what, if anything, might be useful to them, rather than sending
individual issues/patches.

Nickolai.

[2] https://lore.kernel.org/lkml/20261027125210.843589-1-nickolai@csail.mit=
.edu/

