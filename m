Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E1F606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vf8Th39W
Received: by kanga.kvack.org (Postfix)
	id 270996B00EF; Sun, 15 Nov 2026 16:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220F96B05B1; Sun, 15 Nov 2026 16:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112BC6B05B3; Sun, 15 Nov 2026 16:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D86EF6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:09:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 932801C420D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:09:32 +0000 (UTC)
X-FDA: 85438594584.28.98C9908
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE9D0140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:09:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vf8Th39W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIxMAhHIgqQiK3JeHg/MoUdkFWwJF4Zy1XHbF7nLUlk=;
	b=TV9HTAk0lzXuL2tUOYWf4NiuWpZ7LB1LE3wXUq8Jh8atmzY17LtlLOKSD4q6erxsdVNIUK
	1/15C7t6UaJFqB/El6dZ7BCu+1+rydHZ9hccWQOtGvg6u3or00vHffvwvp4/S8U2fLgBb8
	Au1B0G0E4b4DpnFADDeEvnMP3ttLrnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776971;
	b=BfCDaNL9Kr0u+2ZQO+p2iq98YWhINTQFB0Cj/Ee/gxfgERRk+EOgvsWCn5nyrD6KXe5io6
	L0ZLtorPkroan8tr77kiAzhOD6WUuuSGhluwuOvjqd6rsk++JI9dwWwa6ygYkfBICW+mza
	YQ1bDeQ+y4+vCiIFQ8OOSbFSC7ZxLQI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vf8Th39W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B5344483B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26C01F000C4;
	Sun, 15 Nov 2026 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776970;
	bh=WIxMAhHIgqQiK3JeHg/MoUdkFWwJF4Zy1XHbF7nLUlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vf8Th39W8aEvthNwZAoSMhIT3m3nSVljDh+VPZSChi7xIwA1x0uMtqcVTUqb/tw6y
	 yxGOFjUFxUAmY3zWjArPoJYormorz8ZywUfXal6UDa2KZkNxZFfwGA+hxndFbk6Yhd
	 UNpGWW9HnRLaNsI6p/k9Cu6S62wvuSDuwVn0dLIiEbadhlajxFObiLBAwDBTSPUkwQ
	 2y+ST6GltxvbhE8VrdY5+jNOoRLLoEdfZigkGhlavdsIi+xBakaYJ79JFwmvfR3vCT
	 8Ui00UVdGfUZgMq04f9QLeWt2Pkkzx71G3o93Y2KTIPpfUCJT+baI2N1B30tdRjaDu
	 g6vd1RzaoEt+A==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 01/27] mm/damon/api: introduce struct damon_report
Date: Sun, 15 Nov 2026 13:09:16 -0800
Message-ID: <20261115210917.100412-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215838@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9zcz9wnwx76f1bacdw5issh5q3wnwjnq
X-Rspamd-Queue-Id: EE9D0140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794776970-508904
X-HE-Meta: U2FsdGVkX18cFX49sewUuxvEjyW7pWN2WdN5t0kB4jClcP+rlshDZCF9nKgUzK0fAZ6/Xv2bGsH/AYYzndh0/y1t9ofUH2Q5MuykWo5AM+8M6vt8VGM+v5BTlUxJJ1zeWu11lzGTyiwzDv8E4CZe/LCaBcQJDugwQVbxlgbISQFyrN3wuZX1XL5bkoTNVNwY7YOg4v9lWO+g6gIJ4oVkHzF5XdavKzytTiMRoN4P42sp8i3hx9ufB/g3TqW8dxVbWHCxkKyOKU7znU0rYSk3NJTiV4gR82yvJbhjNYahq5q3khWngEpXhNysFklqCwoOXH3zrZr5SOj5rm3TUk87e8AKxapna3M7SPa08IjuPF4XoJrqFz/DjYLdFjL61o6Jm/ph+ldmWf1Vei4CGcIQY026Lkem/lbRO1KG2+Ik4eqJwHhnJXYnAj+/qP2AnBCkHPYWmsT4w+Clr6sEHyG4QIymU0VwGUPAZCXIuDjYZT2+3IkpvhMyUIdRi3DYSkGBhxTzPgDmI44xhYDq2lDA/VukGO6bRGosK3hOaS52IWIHnb7fWR3IsqziMREMn79FzsRXoxkinqa98FTXOQyCpR/qfr/p1kalJlAe2ZTap2taNlQGWY2fpJEckSqlF8Y/po2sla36bFae7esPIf0n5uN/n4um7RSuhN20Qi5M41bmdgGObQWQywE0EDRj6xyJXUGrE5cvBN+Gh30Kpn+/RdG80trCDKPB15E9q5YXEMLAWpovJu1iZvFC/AbkR1JRsed2fq6kWDZSLUIm/9HytGvYkNODQQn75C4aohrmnDf+YqYBI+584TJh4RsVZ6dS/DuO1p7bQc3ZrMvd5Hbdlj+gyjaOo6WeukfGL/jK4y7TcOGxaarqooGqpU0pQTR9owTRQ1roKetjmaYdfiQK+YhElWSOFhAVPd36/3Fj+NPSLq/YepVGk8nyquFZN1VtxlrHnzeM9tKYQmNbhU4
 sBMA6jkT
 vhWFGVXWzc9I2JYyO1MGQyYUKXaljop9Rxceqwtzhr6N3dCaQkJg9jrU1MDmwecJY1bmC0PmbdxhhnnYq5v8X3gugyaiyjFmbmI1A5y8H2HjYW30L1vW5Z8rnrTMCoRauSnQOFB/+LvLTe+S8U6vmqj3mRg1U+G5DlcjFYXYQh8krf6eybkOe83gl0aQoQx5o6tG/cuWg2UTDu8XCCG3fOcjvdYrQMgxu7Cuw7KZ+h8j+nllIjrC5bh/PxWIi41GaA41Mjl1yOldclVPX85TP9rCRzbK0mQ9wYnNTVLA85aju7ZsGPc+tD3XuD4ugBbgyPzNuHd2hr+JhYC6mf2G28+mFLjmwUSBqjddfseyb8cYdsMUr0r9DnB3q+BXhsCTJnPIiRcbEyVmfwuSRm56YyxrE9Z6HDNDChl8PNNTY3kKK/LhCiYnK3XOVRxr+ODcabouH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:34:31 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon: nonexistent fields in struct damon_report kernel-doc
>   comment
> --
> 
> commit 919e8293a0141a206eb1e31c857deac8b6249a6d
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/api: introduce struct damon_report
> 
> This commit defines enum damon_report_type and struct damon_report to
> represent data attribute reports.
> 
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index 06bd92981af21..5c32ddebf4625 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -751,6 +751,29 @@ struct damon_intervals_goal {
> >  	unsigned long max_sample_us;
> >  };
> >  
> > +/**
> > + * enum damon_report_type - Type of &struct damon_report.
> > + */
> > +enum damon_report_type {
> > +	NR_DAMON_REPORT_TYPES,
> > +};
> > +
> > +/**
> > + * struct damon_report - Data attribute report information.
> > + *
> > + * @type:	Type of the report.
> > + * @addr_range:	The address range of the memory to report for.
> > + *
> > + * Note that the @start_addr and @end_adr represents an end-open range.
> > + */
> > +struct damon_report {
> > +	enum damon_report_type type;
> > +	struct damon_addr_range addr_range;
> 
> [Severity: Low]
> The kernel-doc comment refers to @start_addr and @end_adr (with a typo in
> "end_adr"), but struct damon_report embeds @addr_range (a struct
> damon_addr_range with @start and @end fields) rather than defining those
> fields directly.

Good finding, thank you.  I will drop the last line of the comment.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=1
> 


Thanks,
SJ

