Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962F6CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA41A8E0005; Mon, 15 Sep 2025 18:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BF08E0001; Mon, 15 Sep 2025 18:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91838E0005; Mon, 15 Sep 2025 18:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3A28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:33:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B813C0793
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:33:57 +0000 (UTC)
X-FDA: 83892938514.30.5D1DDAD
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49DFE180007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:33:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=kQiGC45J;
	spf=pass (imf06.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757975635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmIdxnQAy5/6n2wVzqJZbhh0D7EAUnPeuQk7BYKKuBs=;
	b=t0qe3vGN6ZoUTxCw7lkPgjIG6V6TE+7RZtqY6kRFTM7HAf1GikdRxVJ5EXh1jPpIXE1YYj
	WsSlXFJTWSo7ehSr0kRyt6xkQgNSeYyEQbxCKWMHda4W7cbWBP7nnuWgOKce1W4ztvS/TP
	xH53b4bVdJgZqDwL7Mwrto6Xwn6Nvxk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=kQiGC45J;
	spf=pass (imf06.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757975635; a=rsa-sha256;
	cv=none;
	b=kdwxUdyKQyLtEhjwMZx5vPoj2UXWQY7X5xfcnKRjhUZejWOwW9tXG4iglDDUBUlxrDczDI
	xEwJF4zmPP+0nYekrAjbnBVSZ7gkUG5jk6SOw649zAZI49PFqBXcuJdHS15S3Xo+CLv2wV
	Dc4UFzlXvWCHO47TrSiP4ke0o+p6N6o=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3671140AF9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1757975633; bh=QmIdxnQAy5/6n2wVzqJZbhh0D7EAUnPeuQk7BYKKuBs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kQiGC45Jj4zPN3+SDKLUz3VE3xbiYaBZRjcUA9tF1yR1GqYAb3CKdNtYUtLK7sssH
	 Y5O2dwB2bA/MZbXT7enkg010ih9TiqQRob4Lw3UgL4dNdZ83mZPUrxod4e9kfQwz+9
	 WT/x9g907sMya8UD3Yt2pzMhZ+7sJMVB9pfPiZXFKebC5IJ+r8PPOVlp/K29nSO/hs
	 ZMkjS7BAXCdpcE7UJIpK/UaAoZKl5QRbycKgJGdVUaXw0irVjUGv2pT0nwHI/Kp1dT
	 C+y8oYX9tK6kOl3WWl2/ZMk6OT7i9utbmvst4UPNMTacnIa/miHarEwYgmjhz3utMA
	 k6aFf/Y8k/STw==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3671140AF9;
	Mon, 15 Sep 2025 22:33:53 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org, safety-architecture@lists.elisa.tech,
 acarmina@redhat.com, kstewart@linuxfoundation.org, chuckwolber@gmail.com,
 Gabriele Paoloni <gpaoloni@redhat.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
In-Reply-To: <20250910170000.6475-2-gpaoloni@redhat.com>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-2-gpaoloni@redhat.com>
Date: Mon, 15 Sep 2025 16:33:52 -0600
Message-ID: <878qifgxbj.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49DFE180007
X-Stat-Signature: 6wo8379zqpcfn9fjpkrwwmb3jcxqa5pu
X-HE-Tag: 1757975635-416998
X-HE-Meta: U2FsdGVkX18ZDzJ3RinpGIajNov1Z8fiDdS682jE0jTtnHr2XvKzotZin0gbQziGZzw1tkpEJ0VsOHzvwMcDuAU77F3P04aPCTih4dIbfGI6rI0AbticqLA/pyhxnUPjZRmEIo6KyfeKrIrD1SIjlTy+nUSk31xKXKkQTjrX2QXCO7+1USdZlwBZbkn3c2PRmRd/DWkPF5uPsvlhvjsH0IkT5S6Ws5jIRlb5lfvCAcr9p+ZU2exE+MuzkaKm6PPu3e4Ywz2+kX0/zPBh+5On8hsdy2TLkC0905mNZec2J+L79z5hHupuCFcCO1RsTTXvl3+NbFkluNwbqCEYPkznXDWw/hJhOm44hMCrzVxV0nYOv4Zk7ikjbNcjPVsF2m5FONlRk+p7TmKVHcGP6tuLEEBa85kjQtAb6aB0rGLmSD6ddTjWlvHQTV4SLHCyIJxTNwTL7yArYXfBPZSL/qVLTi0FSPxcxlJgUws82axSdMIWTEND8Ma3LO4FBRg6GoJxOgD5SAuwWBkw9KlG0BatyoQRIkbJAiq43bXoVOVM+aqq0CXxcUuw3Gp/QCVzkU38k992ACGQsra2RDoXsLEcKPv/+kZEIMShhdc8oqqVfmCIWbCm5UKzA9nWQp6VlZDz+As9GqpbS0wtD2mRA25zCHbZnEvvpJi3n3uX/MH9E4n5zAAgOWcG/q7X09nkHh5sWmy39Y+8+gxCrc5FfPXM5HxhOCVmZ25AOMYTqe1Kda5pLUoYwTjxwf/q5uaYT+kswVAtbfA51bUn5U92ebQrIYZZsfcXBSZxJTIW2hpkWg/DtLVyxIr7ozNuHfHM8g2Q8T3XnhoC2L0yRV3a4UT5dwssJq7vlNmElzbjwuL0RILoy0jxYs217RDgtDyWLkfbITMFVLC1MF/sEPkwy5pkmtDty157Beu/+VZQ9wRBH4FtfDm60cWl2qlrAdEz47dr20xaB2JofgjyqWhFe2f
 n6dABXJ1
 wOc5YGyOOyAXYJOC87FdD30cphUXn2kfC7IOoum9NSh+ygZPQ30g4zVbZqllsBXSFSOj+Nya3Ys1dWJrvFb3dPFGA5m93FoPu/OPAtJWkSN+MQ2knu6qLBjmY7d1O2ClROpsuVU9l9itCiQAQ3eVITtimxmBo7jqOHKSXZZAq9p51nbbXZh1k0SAIghRiktw1UVTCyOmPtU04tyilzcjqJUhldhZvHtOr7tZZQ3pZz6ZoKaCkpSAHmrPMEPLb2B16dDkxjbLov7OuCIOF2sdR2egOrHsaxowYPjOS3/XJS8S8vEVYgO5O6opYYawQ2EH0PiFYStalxo7dJCAwSsxduRagIcVkn6qzDbN3IZr2BBrlXde9QD0TXg7LYqP9xlPIDni5sOA2f/YZd7KorjSXfOyKmXCmEh2sR/4zddHxC+bfprQ66x9Uy8x0DfM9/bpJK5Ju
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gabriele Paoloni <gpaoloni@redhat.com> writes:

[Taking a quick look...]

> The Documentation/doc-guide/kernel-doc.rst chapter describes
> how to document the code using the kernel-doc format, however
> it does not specify the criteria to be followed for writing
> testable specifications; i.e. specifications that can be used
> to for the semantic description of low level requirements.
>
> This patch adds a guideline that defines criteria to formally
> describe developers=E2=80=99 intent at the function and subfunction
> level in the form of testable expectations.
>
> Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> Signed-off-by: Chuck Wolber <chuckwolber@gmail.com>
> Signed-off-by: Kate Stewart <kstewart@linuxfoundation.org>
> ---
>  .../doc-guide/code-specifications.rst         | 208 ++++++++++++++++++
>  Documentation/doc-guide/index.rst             |   1 +
>  2 files changed, 209 insertions(+)
>  create mode 100644 Documentation/doc-guide/code-specifications.rst
>
> diff --git a/Documentation/doc-guide/code-specifications.rst b/Documentat=
ion/doc-guide/code-specifications.rst
> new file mode 100644
> index 000000000000..dee1b4f089e1
> --- /dev/null
> +++ b/Documentation/doc-guide/code-specifications.rst
> @@ -0,0 +1,208 @@
> +.. title:: How-to write testable code specifications
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +How-to write testable code specifications
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Introduction
> +------------
> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to docu=
ment the code using the kernel-doc format, however it does not specify the =
criteria to be followed for writing testable specifications; i.e. specifica=
tions that can be used to for the semantic description of low level require=
ments.

Please, for any future versions, stick to the 80-column limit; this is
especially important for text files that you want humans to read.

As a nit, you don't need to start by saying what other documents don't
do, just describe the purpose of *this* document.

More substantially ... I got a way into this document before realizing
that you were describing an addition to the format of kerneldoc
comments.  That would be good to make clear from the outset.

What I still don't really understand is what is the *purpose* of this
formalized text?  What will be consuming it?  You're asking for a fair
amount of effort to write and maintain these descriptions; what's in it
for the people who do that work?

How does an author determine whether the specifications they have
written are correct, both gramatically and semantically?

Thanks,

jon

