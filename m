Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B43C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2808E0002; Thu,  7 Aug 2025 12:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53198E0001; Thu,  7 Aug 2025 12:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41F68E0002; Thu,  7 Aug 2025 12:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B14738E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:25:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A4321DD970
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:25:05 +0000 (UTC)
X-FDA: 83750485770.07.1C11CA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C5E9100007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:25:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNGB1fF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754583903; a=rsa-sha256;
	cv=none;
	b=7bbNiqz1Jhk9Bho4cl1/Yx+UtURiiBVKhrnEbrgm+32XFOTLgo3tL5MqdBCnHGIJLIvGu8
	aeD3T1kPR1Q+E4+uAUS3IYLNwtq34Ya2PALhjtbR9o6GdUMevqgEDhXHdJIDKOlszZdudO
	HyRXFxiUSJL8rnM3I5U4ylzPsm+f7UU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNGB1fF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754583903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYQrKXbWAeXIPW4FYuGyYDj63TM/qswOZ3LZyiuM6lA=;
	b=glNu5g26C7s4H0joYScyxIriH9IwuSiwVZenLUvFQBl9cpGbG8nSXSwuHj8rq5ZF4+aq31
	QxtkqFrmoVjQZBkGOFFrEU7sQbOLEfjSHqZ3pjVaBD79tuetvDM5lJxK0yAYU6jV+y8QTg
	bfrNNT/xhBhnASnow7z7RG+EbevaQXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3439A45AE1;
	Thu,  7 Aug 2025 16:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E7C4CEEB;
	Thu,  7 Aug 2025 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754583902;
	bh=gZuBfBfos6lnetLDGbxB+b0JOP5wvWRXNZu2oo5TIAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNGB1fF+zSer4RrcHRNtDc4XjWOFIpr9Akj8vMOxKglY64CcCS+atMiPTTfgAy1FC
	 J48secBhJX/fCDNEvnaclth1xE3MIgng0MEdsnSgKvECkDYpOufr1FlGc8HL8+IiXz
	 lA3Xl2msKWXsXMLiP3JCeXIBBu8JZsQSxEKyE7H9AYh/oHjDF6viWvutOImxa+2tHL
	 7oN3DDYzZjVYWBSq1V5c//1tRGa/qGfm4bH0o2K/YgnfVhzFxjFGmNtqDmZNiLPVcj
	 0JtJRMVklulGL0ZqzgaTK7ApGaWicj8qZyUSBOCaODq/21fOPzmLksZ4dGYyMFfgXJ
	 lUTeagY+M8Rbg==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH v2] mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
Date: Thu,  7 Aug 2025 09:24:59 -0700
Message-Id: <20250807162459.52683-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAMvvPS7mcevjD-b2vz1P+grQfffVA0bx-x5WcUQ8=JApD+UkHw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mufga13mngcupykxchseqgxw4f91pp5i
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C5E9100007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754583903-201443
X-HE-Meta: U2FsdGVkX1//kPwtFn90FVfqxkiz1s1jwuTmytbwQCuJ8lGZE6x4DQmvGWOx/sfcYuScHQ0MwxBP3zdy5psrn/Xx4HknVVzF0zBk6YPa7nhZhLJ8bxP+kRdyMxlAv3J1k2VtlLj7a6y+4Wn4mOQ2bMrJ5plcgtkPBc8ukvko42199+3pR6XZtWl4/hz1DWRPnKfDU+oDb42C93QZNoMmpQjObAKAdlqh7FpfPN9xlehnmupy+WtwP3LUuvR4vpE1Hea8W84lxkD3NLwO4s7fe8WKwcR4+wnLeAaJfy3M/hrRJCVhhAOGyRN5ZKSP/2U16Pho8bw8F5qAqncnsiRrOl7CZiKAChdgdMxUuZdA0Lr72ZB25IiAEBd7I+H3UQ4obZTophfXPMzypIyo4NYF/Ek5Sbxqz9cE2cFZ6BjCqVnhe7gQcqdtbeWf2CY/AYzU6kBI6UH/doI8iGj6btXPqDqfDNPkytMJ6phUyd72Jv0GXQZk3JTl8pWo7qTybe8VVjXG8ul6NaYtOVcaQeHet1+U94oWrmkZmL+7wFM8FRxSywBduWzs0cS5RzPL2JxTdra+Ffb9kppGMG78ClN/vewYzpArOdIt6tm5VTTTS7n6rSUxOraEnjdlIy5ZlOpYALKwHGmy1sMPRQ7/pdE7Zx80VHKXwA2i0KituB30dF0BKrknG4yLIX5rGIqcd3lNTG7ZVKegvAt6PCmbVa7L8ihKzLWEvqLZjsaA0VW/KKkDDKE0jHvb7WddCeUYb/5awpenwmV6Ae0Tqbroe54D4qU4/SJgtxyWlygDa1+OiKtqy1D7afNrPptxC8NAlYDtWVUFHRIu4459CSKVRXAwmJ6uHsG5UMBpx+RP22n1TLpofpGebr/etisSKGNig2kfsVCBeTlyC8LJ8cPGVF5gqc0TVGu/dA7KM6tuo5bCa4b/ETx3LoQn18tqcjfbkCeEAzwUspWTtIGbF1ZpvNd
 q/mjm4/G
 BWQV119pJHxCRWQ7KmL5WgSCZ6sLoRgDCQdO3ga8xSIn6MnTIrIIRwtL5YeI6NRsWKLHyWBITIUcxudcA5x8hvwWC3MOyL52XVfjJJmA0QNIepuexOB54LgbMUPlT9tSD8M9KLe585sSX524Y1j67TeDIr9vWAn04XDNSyCBjTsCuf8I2intJrjQxgCwLw9D6FebOSERsB/EGeAza5Ge+VS0ujOi+ewgNeS1p1QV6c+Kub3qFrO4lqFbt5AKlzwXShJ7B6e+OjUl3SmW+YTjIEtoShzRIQY8LM5qS8ngkMv0MQlQ5nkvxXQn6G1TdIpkNK+U1Pg3Q/uN9/b62YFYWzoYpaXrBBO9jUBtsGXgBYNxYmDQ7MMzwyb14Bz8gtsZvBSoKKHYWlHQx6KE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 Aug 2025 19:48:44 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> On Wed, Aug 6, 2025 at 7:19 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed,  6 Aug 2025 18:42:54 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:
> >
> > > From: Bijan Tabatabai <bijantabatab@micron.com>
> > >
> > > Currently, damon_commit_ctx() always calls damon_set_attrs() even if the
> > > attributes have not been changed. This can be problematic when the DAMON
> > > state is committed relatively frequently because damon_set_attrs() resets
> > > ctx->next_{aggregation,ops_update}_sis, causing aggregation and ops
> > > update operations to be needlessly delayed.
> > >
> > > This patch avoids this by only calling damon_set_attrs() in
> > > damon_commit_ctx when the attributes have been changed.
> > >
> > > Cc: Bijan Tabatabai <bijan311@gmail.com>
> >
> > Maybe above line is added by a mistake?
> 
> Sorry about that. I added it because my internship ends this week and
> wanted to make sure I get notifications on the status of this patch
> (e.g. email notifications when the patch is merged in Andrew's tree).
> If it's inappropriate I will remove it in the next version (unless
> Andrew does it himself).

I was just thinking you might not added this for a purpose.  I don't mind
adding this Cc tag.  As you may already noticed, Andrew merged this patch as is
with this Cc line, so seems Andrew also doesn't really mind, so all is good.

I hope you had a nice internship and continue seeing on the mailing lists :)

[...]
> > > +static bool damon_attrs_equals(const struct damon_attrs *attrs1,
> > > +             const struct damon_attrs *attrs2)
> > > +{
> > > +     const struct damon_intervals_goal *ig1 = &attrs1->intervals_goal;
> > > +     const struct damon_intervals_goal *ig2 = &attrs2->intervals_goal;
> > > +
> > > +     return attrs1->sample_interval == attrs2->sample_interval &&
> > > +             attrs1->aggr_interval == attrs2->aggr_interval &&
> > > +             attrs1->ops_update_interval == attrs2->ops_update_interval &&
> > > +             attrs1->min_nr_regions == attrs2->min_nr_regions &&
> > > +             attrs1->max_nr_regions == attrs2->max_nr_regions &&
> > > +             ig1->access_bp == ig2->access_bp &&
> > > +             ig1->aggrs == ig2->aggrs &&
> > > +             ig1->min_sample_us == ig2->min_sample_us &&
> > > +             ig1->max_sample_us == ig2->max_sample_us;
> > > +
> >
> > Unnecessary blank line?
> 
> Sorry for missing this!

No worry, as you may already noticed, Andrew thankfully fixed this, with a
followup fix patch[1].

So all is well :)

[...]

[1] https://lore.kernel.org/20250807033443.BD30FC4CEEB@smtp.kernel.org


Thanks,
SJ


