Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FACCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969B16B008C; Fri, 16 Oct 2026 10:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A9A6B0092; Fri, 16 Oct 2026 10:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FE86B0095; Fri, 16 Oct 2026 10:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBE26B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:01:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E949E1C3C3B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:01:16 +0000 (UTC)
X-FDA: 85328651352.23.EECF435
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25923C0013
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:01:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDL9W2ud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792159275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnjLVyf6myQJUuaqwlYmu6gwLwBU3rB08827vgARd+U=;
	b=FoUi3M7y+NoziWe5P8OuQd+7QC/7X8DyVccwZAiRNU7ArkNKSqt99V8VJ+tTSF9ucmbMaX
	LTa5gt1B3RLybRhiqV2fuMNfau00Ar6OY8Kkml7NOhY6gL0UBnw1p1RoCWmf9ZOy0Yej5E
	QyF1WBw9ra/kZL3YHuRXwAgAp3o6jIg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDL9W2ud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792159275;
	b=PoGmo+hez2aHompzASRVwx9PZlUqSVLnQrXj8evQ0s3dwZySV+UYvp69/QkZ78Fjw5LRB3
	ho+aG+pybOkFwTnX/HEByUIBjES6t+63ETmTpG8ZJaEUNGr7cxRNmcDo0H6qyY3/PcP/i9
	bcLTVAUETcTk9lCo0g1a3jrlewFHN68=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F054E41E90;
	Fri, 16 Oct 2026 14:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47001F000C4;
	Fri, 16 Oct 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792159273;
	bh=pnjLVyf6myQJUuaqwlYmu6gwLwBU3rB08827vgARd+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDL9W2udIs5FpN86pee9VwvNSEcCwiRcEJhZjtShWYoXLWqigbOI3aCi+1gF6/39B
	 18Bq2/AqbZy6AYPsUmhAzCwOMrlqZNN2VnISfElelz8dVVvKo1DMwJooELZk8rYjIc
	 EOqdw6Y6kWcJA+Br/3AE+8v6urwSIHfV3CVi4Bl2a+XOjDXS4UHKuT2ossucN7Evbh
	 aqrMJf+xnwJlwpagI0CiK3dYX53QWU/mu91bHtwtEpvF9QgCfyUvVxxYydMUT8JSFy
	 ctrF7QokwqjJU/PGB05ORjgxEfU1+la6y2kgTph5GEXG+Rm2LZbXNQqohoT497XgvW
	 jU3GJM+z4V96w==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
Date: Fri, 16 Oct 2026 07:01:06 -0700
Message-ID: <20261016140106.118283-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmHMRh6Sa=6N=hM8VzO0HRaFL0FxQB7An8=Y-X5GX36kmg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jhdnzaosqhnru5ctt5n99ib4uq788qbn
X-Rspam-User: 
X-Rspamd-Queue-Id: 25923C0013
X-Rspamd-Server: rspam08
X-HE-Tag: 1792159274-584437
X-HE-Meta: U2FsdGVkX1+RKb00z1uyPgbDuPg28/W2tQzWZCjELz7uvY3my9/rg4uycoPv+wSJ57BRJPMc9Os8X2hV7dfXt7mF2yZWWEW7HKT99cAQHkUujwhwobLJrR8KqEEo7beXK6pg5rBCt/w6sVKJkWKtcDCIVENcAOsMCMiC/Nqc/JFAwFZcWAk1D1Rqz5NoV4iYJO9bharjODmnwUG6IE8qAlCYFUR7k91CxKIxuVaipJgVYa2TQ+eZ0elWBvVJwliQ5Ydwke46T4YLbAEGC9eWkWfRg/X2K6ItrL1YWpN7v3e3qwvW7QsbXOduHSj5DLXMFxJkvYfLcx9CO0j8q9C3joL/s65g94z2Km1b2HCNSzddK7HgX1AkMDFul/TGzqsBvV96Yfs0lrKn0UyLBGa5WLVCamAhBOPBR1qZXF9GpS6pPRCg0BDBidou9lnh2YpgHs93UKbLzu7ka8YkkEr2AfBeUQLQp2Ja3P7aG0V32n1uJIUNODJihQJzsNDgp04z+7C+hUR44c0YmvDK4ZNu9XzlNzosgVbJh+SBiaEuLozslFJ3/MOfK9Pj+3nY3N/nimOjMYRzwOvMlw8niNAAxE5CkgZuIYDDBcV3P/KuFahF59XVxyTqIexDWzaRLfI/GuFQxQwxNB/CFd8F3fkVsrVIqbuca262HIewbjojLLwH2YP7WBEKi+GTCrjrXNBW+0iAdK25T6yJLjcAE3ZynCbhtyPpC1ba8tkZCEfmsUWtG03s34m3qgogwS6BQfhLNXQWzzh/et3jJ+fm9E6HtSeY5L5z3gRhhCz0Nkp3jsp8IXnX+7vBtOB1i0qETdCXI1AFq82TsOqUcr3ngxn/pAjJmps3XfEM63oF8ig48AVmC/nvPlGaWKu2ITbusNNjZu+KX0DALbyYekm0A88511LVmvrOCIKdE2XJQ4J/mdSkh/OMCuVyJ3ZlE5Sdx+1CikSuCUlKwYGHcw8xvdC
 NZW3+xn9
 4UaJnxWTk6TNsZe7/lcTEuaOWw2jhURnOYH34MJxD2xpNUEq0lMmEJmwvLNvcFoKLde+SWMdYARqduGZLdmckUB42jsL3GFPaiaEMi9XjtIxtAMnzH8rVOL9r2s/BOXGChIeEKTbc+6z0P75JHry8lA6A3ubHPBckURgFJp372WUqDdwKwP0K+s+a14ekz3LMoeMuogwB/KIieE3+xrSyqcVzDh3twGd8v+6MycILLQvhW0ehE7n8hzthkTHQff37X0T84RIzvtX+RmV8S+q25klwig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:12:25 -0700 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> > Please do not "top-post" [1].
> 
> Sorry about that. I'll avoid top-posting from now on : (

No worry, nobody knows everything from the beginning, and we all learn from
mistakes.

> 
> > You shared 4 bug reports in very short time. Three of those are
> > from 32 bit.
> > Could you disclose the purpose of the testing and how you are
> > doing the testing, finding bugs, and reporting those?
> 
> I've been trying to understand DAMON in more depth with help from
> an LLM, not deliberately hunting for bugs. It spotted a few possible
> problems as we went through the code. After checking the code and
> reproducing them in QEMU, I thought they were worth reporting.

That makes sense, thank you for sharing the context.

> If that wasn't the right way to go about it, please let me know :)

That's the right way.  Nonetheless, disclosing this kind of information is very
helpful.  Particularly nowadays, use of AI-like tools is nearly always better
to disclose.  It is not because maintainers hate AI.  It is because AI-like
tools are still something new that sometimes good but also do mistake, and
therefore maintainers are still learning the tools.  I'd suggest disclosing
this kind of context in your future contexts, not only for DAMON, but for
kernel works in general.

> 
> > Why would the tool tries to refresh the regions after the monitoring
> > is stopped?
> 
> That's probably not something normal users would do. The test
> deliberately called the update after monitoring stopped and found
> that the failed request cleared the old snapshot. It looked
> unexpected, so I reported it to ask whether that's intended.

Makes sense.  So I think this is not DAMON implementation problem.  Tools
should aware this and do not try refreshing when the kdamond is terminated, or
remember old snapshot.

If this behavior is not documented, that's documentation issue that we shold
fix.  Please feel free to send a patch for documenting, if you don't mind.  If
DAMON user-space tool is not aware of this and give users unexpected results,
please feel free to send a PR for fixing it, if you don't mind.

> 
> > Is this an answer to my bisection question?
> 
> No, that wasn't a `git bisect` run. The suspect commit,
> `66178e4ec30a`, came from code review. I tested it and its
> parent `cce0b334c310` with the same setup. The parent kept
> the snapshot, but the newer commit cleared it.

Ok, that makes sense.  Thank you for letting me know this.  So, this is a
behavior that changed from that of the past.  But I still feel the current
behavior is not a real problem.  In a sense, if the kdamond is terminated, it
has no region and therefore showing no region makes sense to me.  Please let me
know if I'm missing something or you have other opinions.

> 
> Thx for your time, and sorry if I've caused any trouble:(

No worries.  I'm also sorry if you felt you are suspected or not welcomed.  I
believe now we are all good and you are welcomed.  Thank you for kindly
answering all my questions.


Thanks,
SJ

[...]

