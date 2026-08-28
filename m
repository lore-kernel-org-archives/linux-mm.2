Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD1FC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61F96B008A; Fri, 28 Aug 2026 14:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13CF6B008C; Fri, 28 Aug 2026 14:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29FE6B0092; Fri, 28 Aug 2026 14:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A41516B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:32:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34F03C04BE
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:32:40 +0000 (UTC)
X-FDA: 85151524080.05.DC7DBB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94E041C0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:32:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYr3tu3r;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787941958;
	b=QmNjo5KGpEj39QmrXAjKjy6HOUdTQGfWwe5PofcZRXUIQvb0h5JcmFXGhQ5okKLbH5zsQi
	ze21alw0lJfbw2uoFE/7A8qFOzPyGruciOfsDLXEHZwdj1pi4VCKpEt7RtCSrOySyJ915Q
	IJW+ckQOqLceCiGdjusBU1fhD2CscHg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYr3tu3r;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787941958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABzg8YpGTvxs6hey/VNDQl6c5Dr0N0qxeGAAzhfOySw=;
	b=ZvZ4x68RP5/vGh3huTxXzoYAEYRMqJM2DNyRvCEZFcAPf18nF4Pf+Mpe37If9/zIHhxuTK
	vylaBxmOgU5x2IIJNudCh7JI3C/mk6ZgbY9/3LSiAtCknwrFHA5bwlK6dJNkCBmhJAAnNC
	HgygAy5SXK1oR50ZTH2CyZ5Q9Wc0dFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B28364327E;
	Fri, 28 Aug 2026 18:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6544E1F000E9;
	Fri, 28 Aug 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787941957;
	bh=ABzg8YpGTvxs6hey/VNDQl6c5Dr0N0qxeGAAzhfOySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYr3tu3rftVInD8hI/OBLLJivWgGSF1DEvvwXVfBHSSC8j2F02/X2kdiP0xFg/XHt
	 c5JevwGA8ABY8E0/zZ5YOWY6yoRT+rwbYTbyy7U6UN/rt3yKFclxv4vXz/t/MrR8FQ
	 W/Rg3c7dV4jFD+h9fF9E/j7nYXLSl36m89FTTU0GIP/RH9nYwDoeXBAFJDydOPOMxW
	 AOVqeSHShtUhFh+aZNrOAB3phRBKdm1cKjh20O/kT/S5O9aKym0QHDr6UC7QEhs8Ja
	 Hm9mflD1+P8Gyj9dzOX/Q+3rP4PyJr/WGYRnHxHC+/o9gKWrVszCtX3ffTiZeTv/Jx
	 mssMBwW2WyZIA==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 22/37] mm/damon/sysfs: implement cpumask file under sample filter dir
Date: Fri, 28 Aug 2026 11:32:30 -0700
Message-ID: <20260828183230.70517-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3cb41363-76e8-434b-add3-3cb4b83a6d9e@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94E041C0002
X-Stat-Signature: 7rcx6c1s1nsisian1eps83m6msziqcws
X-HE-Tag: 1787941958-61042
X-HE-Meta: U2FsdGVkX19QDdIY+u9i52UgXH0SYHKkYQBqYE+pwnpQ6q7KoHXEe2Kv9wYzt4gdefsA6MfMuKz8ircBj7n0WfzAJNDt9syiDS7B9YJnd/3oCNIjNU/IdwLm8r8R1t/+jumCO0XCROUxSckZT83R9H9mxTUXjbQf9cfNVTwg8/fR/VCr4dBa8KVB+NRp6QDZKNgaVGFs3kLOodYeHPkFJOMspyP2cAZ7S1OfB0M8QlRCoqC9Z6+fVrl/SxF8WjEkUa4cmQVaKqxQwRbJ9a9T21YY1tih0AHTfhPNadhu8bYvZ5h0hHlBj0BxMSpe0k8TKVvnvQxW0HRzp8itP6i8v4aiJUzGb0S6TgXZWZdf4i1MAd5WgkGopoumqbyOE5KvLyAElOL4G0t1Z8JCHN3n9x9PtVJIlRb4yONlG58Hfl4jLBaGDioLZk1cbE86eMVrsAbcc1i+pWc8TtUIxmvbgThxCtW7XmX4s4wFzmj0tUSCu5dO9ktCXEiPClGhSPy+P3zsqlrbs+DP7wC3cuiOYZFlZ4G3gHD0405cTkQaEFQg2zvXfrL9KmeMMT0Mp5sQDF1cdu00059Jg0ocjVYNFOpP5irQJhvinnNBR8Wo1UaKbg3ehr3KkSnlMVmDJXjz1Lf8sMMfuxY2V2+WneK4TskBsNY75Nh9hQJogBt0ax/2zNbu9Nea0ZUC6Kmv/JZUrMVRmJ7GkZ5XysL+bM2MIgY5Dvc5YKWCAqaN5z5VwYUZnSGZgPxBy26mBrS530c7dh0xwqPeREmgnM083rrHY+kyJSSb8SHEPIRmf8pAir2ZA4aoO2XcBKEfo++3hFUjNiA2krgzB5ZdRyCt3zcumE7t4ElBvQrW3h3+gTo5J2hAadKDQ71zSRObjmJv1wj9qZdS3GR+bvSQWxdcmrUlh77Jcsx4BHvEwP4i7Dig6gmwRDc5VOTHEtZRN+5YeKQ9dKOhiiRcpzM6iLmiJBt
 1ah3Fk/O
 Mr98tkRlrZpHs+oF4zC9JBZ4Qy4Pk3HwiRus8iox47lv2PJJzzzhF1ICV7yW1D1ukpDwebqUAk2xKBoCn70sxQQ+2C38p4U+iddofq6LARCuLnJx2g3KE/a6selbkqOocQ7TR/LLoLh2Fa0YJp9RZSWL5E6A5s4TJHcDXoqkmywlzDmtfmboURxCZb73Jku8MUQY+uE191OJZsROmhJrdL57r7KNV3LCegl1XdPYJ1NLU2+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 11:59:47 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> On 12/8/25 2:29 PM, SeongJae Park wrote:
> > The DAON sample filter directory has files for only common properties.
> 
> DAMON
> 
> > Add a file to further specify the CPUs to filter in or out.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> > 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 74594e6e461c..d6b0b6513fd1 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -758,6 +758,7 @@ struct damon_sysfs_sample_filter {
> >  	enum damon_sample_filter_type type;
> >  	bool matching;
> >  	bool allow;
> > +	cpumask_t cpumask;
> >  };
> >  
> >  static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
> > @@ -765,6 +766,19 @@ static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
> >  	return kzalloc(sizeof(struct damon_sysfs_sample_filter), GFP_KERNEL);
> >  }
> >  
> > +struct damon_sysfs_sample_filter_type_name {
> > +	enum damon_sample_filter_type type;
> > +	char *name;
> > +};
> > +
> > +static const struct damon_sysfs_sample_filter_type_name
> > +damon_sysfs_sample_filter_type_names[] = {
> 
> Looks like this should be defined in patch #21.

Thank you for your review, Zenghui.  I will nearly entirely rewrite this series
using probe itnerface, following the DAMON extension roadmap [1].  I will keep
your review in my mind when writing it.

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

