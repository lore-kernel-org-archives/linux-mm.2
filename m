Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C38BCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1FD6B009D; Fri,  9 Oct 2026 09:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679966B009E; Fri,  9 Oct 2026 09:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592DF6B009F; Fri,  9 Oct 2026 09:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34FE76B009D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:54:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAD861C37C3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:54:47 +0000 (UTC)
X-FDA: 85303233414.11.5681054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 172C61C0009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:54:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIEiTfVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791554086;
	b=P975pgDtlHYX3MVJyyS5FzB4hkPVfqIKodU6RmybG/vPn5TLzAtY4CGrV4s2k4EFHHhci3
	snxuk7HGIbKGY/9U3W3YyYnVXu/Ha5j56tjhQZuwXIr2DfP80NdOHSzeLnZJFsKAgVtman
	B4aYG6WhPEJt2lwWYiOtC8Fwh2KNzY8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIEiTfVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791554086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPhGoc9Ld/Il9e/6OU3y+ZCWOjT8Q9T6KXbN4b5BmK4=;
	b=FO0lNxI2hFyHbn5YU+rJJKmFg1EZuRwshj5GQDSaVDD7deH9NxRz9OkVekoYreG4dOaDEi
	ulEShfuKOdG3hpKXVpsTVIFfwi8ffA2hI9PNK38TnHrAtVCK0KKK65NJhj25CSdHIypCnQ
	83l8Gf622+kqn7kaeZAaIU+Ss0R3KHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4000343D48;
	Fri,  9 Oct 2026 13:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA3A1F00898;
	Fri,  9 Oct 2026 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791554085;
	bh=MPhGoc9Ld/Il9e/6OU3y+ZCWOjT8Q9T6KXbN4b5BmK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIEiTfVeOUBYhEaPTgJLU/abBGXVDkI4kP9nKe+MqxDPFQ6nHUQ6hNkmFfLwwmz9o
	 nGoqWZ7a3NQ48BjLOq4e9s+KJUOPmASQ+ZFvGipN3NOtoLUH9LCEqwIfXhwhBU/Arm
	 buY0gkD0OQijkFM8MED9Ef78i3Zn0ksRTp7X/ZG4NsWDwd3uBQdI38VQIcR9tSGt3v
	 pc4woBJhDxqQRaYv8dTp0CuQyjA/K5XNHPYZx0EhPk9qYGFnobS8cg5hLcCYIGbkmv
	 PJDlua/y12fmQHIbEqff14pWYJPwInhaNDr+0eELcwU1tEALjCw6cjAB+kuBymRPD+
	 Y0HoaAxRQ1/7Q==
From: SJ Park <sj@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: SJ Park <sj@kernel.org>,
	Arnav Goel <ArnavGoel@woodstock.ac.in>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?UTF-8?q?Re=3A=20Research=20use=20of=20D=C4=80MOS=20Linear=20B=20texts?=
Date: Fri,  9 Oct 2026 06:54:40 -0700
Message-ID: <20261009135441.11570-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <asjh_RkmMyEUZUiP@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fegsk794hozhurnwbsjjb1r1yckkajzj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 172C61C0009
X-HE-Tag: 1791554085-638077
X-HE-Meta: U2FsdGVkX19u16TH4U6Ph9nIR2Rwos80SmbjxsQBwJqCiEpzcqydGNtx35Nl9uigYLDLdn0YTlFtwmO1YgRxL4BSz8ZJ/lpNYQBslqcYW7GqAb3e1xy6PsQCKtlVbLQm4ErYGj4Tx/YaZmT6upjlG65wq3uSoxpHPw/aACq3IVQc897rVtEj0GSf2yD2SNaJ0rF8kJD7zB81PilgRr/ISiXmaYK8I6NF0lYfLlPR1qC9O5ds2YhmOxXwJwoqf594YqjdEnMbZjjpO2+ovK8QdF5vWO3UpQcLgZG60Oi9+3TjcL/e4edG2FFFuKraRMaFDcl7hl2KZEcSUkUPLzCiUYpjnVYvWP/aPuVnviNLm6MLFtrLPBv6/+ysfS+tXbn+6NDYjM59XDsklDQ37rDL8Ue885N+ZjTtrcYOgwR5jcDKl1dFlIYhWujFnj1X98Q2wPIbreTQ7UFrAWJY9wxzvh2iOqmQNyrALhecc/mk9UvCcuIY/aQ+4puEvRSZcXznrt6TyZ+gqLYDyiBktYAE2n5mo0JVEWhFNh6c7vmaqQUlZLcB2hXNU1OlBLJ2AynXNCILBjR5JOn0Y+Ckh3vC89PD3rOrFX847tsGudr6mybPuBlx+r59B/lXgv2A6Wz1GClHyxGk2x2wd7uMYbQQKuXy+enTpt1EoHyoIotUFsEXQBssNmOuugfqmKWzjJzfAjiyn3IcI3Vxw8EnBv1Zs1Hht8Yf/Lj58uV+qpkUI4MGuRqB5ZdDVHHEzCqtMXCDRYmZ6dbDEkzGsCsGmcuXIV28OaBMxzKN3YQe13VME0fFLXQsDC1RDVuFvSN60WqLABowOBMTB3pt03j77ibuvUMiuwJocm8oO+djoBJSXtglzKzBqYBXMrLxC7rL0goavaY2LMNKldLKSvnUCblf8C8VY6Gx9zlI+SwApQmJPjSB7gsJX/W3VGtGGpjo4oHxoypCG4AewD8JPC4sFZQ
 TCN6LuEg
 Tb2OjhBk/g2iN5MQZJQG6eS6MjXfDBZH5r3QzsuG6QcVcfY5EsET3iLakp0yNiO6GUiEZSIroGcPzen3+SrWd8XWdUdhQHSWm0lsdxZc6+4jk8VgaxFPnMLEZV4dcL/Wwjp2s1htBn0sk/9EJOboMVeIcI0gSMPZB/GF+UQjC7qE3IxQPd+j0T5/rZ1Y0Un2wOxum8kyaq67IO8720OKP7V+wQPEbpHpk78umEIOLfLGQDjAgvjiUQ7UQcmKvDbi22jwLGUSjzYDXqa1WQQ+XRNrek8dzk7dCDq/AOac2S/Hvq11RTmMznzmxIQyCTDYT6T1lAS/9TtK69leqkmhwvXWyCGdIPmgvLb7D0PMP/RZbmUIdW7frzynr1pT/QEXSTodL3qfkjJKx7kTMXcj1lI4ow8CHsJB+hXFXKuYP+WwDtY1ma17oLH9f44taRfOeN11tFLsuL2Wrll6NcLiCu/+KF4Iyd74CML+S81hjJYB2k9IbAO99c3y6RHrYULSx11UI9T8dQGw4RrtWDEHB1RRaog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Oct 2026 13:45:49 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Oct 09, 2026 at 05:42:41AM +0000, Arnav Goel wrote:
> > Dear DĀMOS team,
> > 
> > I am a high school student in India building a benchmark that tests decipherment methods on short-text corpora. Linear B would be an ideal real-world check, since its texts are short and its language is known.
> > 
> > I understand DĀMOS is available under CC BY-NC-SA 4.0. Is there a way to export the transliterated texts in bulk for non-commercial research use? I would cite DĀMOS fully and not redistribute the data beyond what the licence allows.
> 
> I'm afraid you're asking the wrong people.  This is the Linux DAMOS
> which is a Data Access Monitoring tool.  You should probably be talking
> to these people instead:
> 
> https://damos.hf.uio.no/about/content/

Thank you for kindly explaining that and Cc-ing damon@, Matthew.  Arnav, as
Matthew mentioned, seems you are using a wrong contact point.


Thanks,
SJ

