Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF65C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CA56B0098; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5EA6B0099; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E166B009B; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0B666B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E71DA3D53
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:42 +0000 (UTC)
X-FDA: 85150803444.11.799FB66
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id A0DCF20009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ct A7Dgd";
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924800;
	b=v5qDnvc9rTzG8QCpCwj3eMrhFKI2ieQpRMMjlw2Dwxi3ynZ72dT+QzOruXArS03cTbv9CO
	AxEp7JFuWz4bvDM2BjiaSRzHKZ9E+ckPoFQO72PU7i181u7LMIC6ig5J+vRnH2/UBjW0rL
	WNpGbUFUnEO07VFVX2K4kqXlN02qJbs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ct A7Dgd";
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R/cHZ9f+AKwXbLDV25J27rvOAvjlInOdxrZWedG8Pdw=;
	b=Coti8JaZIs3RPIGqsWelCVf1JrvcV2n97ElZNajNC4bzGYF8vONIPEuc3PEFxKz6apzGQE
	9Bjz3fzTfvU3cLx0pqQoUqfbL9igCKpWciRPwdfxd1euWnWyXkRdkWsdVQjjNUO3X08bTk
	H3HoT9R+hXVB30QnIgOfaBRZwJDgOFM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=R/cHZ9f+AKwXbLDV25J27rvOAvjlInOdxrZWedG8Pdw=; b=Ct
	A7DgdFdcRGEn0sKd2G2viWBh8uaj1wTRdnaUh6IcaSw/IdC4/QQqHBlxnZSR1XBriu7JOoUKySgLr
	PSCS5uSahp774QactqKZFVTlF6+rx30I989eGTwQSd357AMXvcuSemJUMxAMwJGWcbXzGm3WT0/Nw
	GyDQ9tDSRj/c26SdnoaBYPMdFQjaG3Yd6PLc5Ktu8foXZJHNpBjuvXhOnVtkp0CrqT6yT47uOl2ph
	rLaNu2AtqzRhsxHzzfQ4TniOtrXt5rlB11eFjt7sLglfhYALVWkPQi6i85o4iL78wNOu9alUko6dL
	+LR/HfLjI/zV9W5VvZm3IR52ebbe8A7w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0fEt;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 0/2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Fri, 28 Aug 2026 09:46:19 -0400
Message-ID: <cover.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p7387bg9ak8b1g16h98izytg8f5fnbmk
X-Rspamd-Queue-Id: A0DCF20009
X-Rspamd-Server: rspam06
X-HE-Tag: 1787924799-135762
X-HE-Meta: U2FsdGVkX1/DFwecy56Qlgrv9gLf+UTKqOBGIIfSo5aiJCek9Md0sSGzLOEAtgyunk31x3W8rO4yqwPsDnr2xYl0hzme9RSy2OylHjxw/GYOg/x7QxRUSvCwqk/SxQkOsSzoxy0+wQSJuolO46615T1Xfb3ATZqcdpSIaI6C5Gn3WTp0aCIqGUaaFlXejNw62dyOxamv8P74tgDJoSPXXFQkpy5EzD3Nxi1hvr2csKAoYZOz/nHoJTqkjgn16Bhn/icctahHzmbWM9FWZKHbL7q+EgUKhB+OLYgMIJc64UocEn9nkSphx2VVuQzWfH8RAHeikw2bTvDGfCB2NByFrA1oiwPPHvJopWXzCshDEEnOdme8PaRbmI1kUfNDm4aDX+ct1loj2vG8DoyMTCi7eMJ1cssDGgNB8M9QRqPDyYHnjuGOrhKvfcJwrz8IHyvwwATHjqKVPWdz7VBI6lfEkt9YB+rXCwAqApmI6nOoLgD7QJVf2oIcuuN1zuOjG3s0nI4fA+Aq6De9zb1pLnttOu4pEMN/TlIN665jHpfdg6PxXvwquZjrvc4s7Zi0zCUjwwnwHDeOGNtAuNfqrVShjq+wEJf7LRk0cavFlFUCS9ap+z5TkYTzncVhPT1cAQrrFBYTMZrCWtlvb4lIEExvAT00xdXP2k5gYz0zgmv+XiG7IyS23oSDyOs7H3q/TGAHeNgadbIaFTG3110ZiPf3K2kRLyz/BrAeTyYfod8Dv0z5kQ8NYyH1P0PXmCfBiABu3SzCjgppQjbf2vmamfqPLg6QT8UMJxP9U9IdKNCXy8qkT71x8oyXCqZnu7H0+eTE3Dj8Re5UaVtbTOSxR8yiluMey+ZQuz3UajU6nhj6KBNsoVEQgAcLkfF/kr4hfqJ6Hymc8o440d00lgDaZqGaBDKUY9YvxEwkcbF38libMdJxihlDE558lpvKIioFBXBO/zZEke54rJ43Wb0ME8d
 Brt3YNtI
 Xh58LN7si8HUF8OfjO8gMjv5AkpESDtpUOVEwIAxnAmOSQpO+IkripznxsyPjfI+XmQVTS5srUHr8o3JGGNr62/HLlLCZm6qotUnFgy0ZgSq+V7IPzgE7TDxTxYD201V91K1gqszB/u3FRRiLbQXHCJvsUt8ZAEsF5VrrTS6zh3PHVkvdOp8nZvKymgYR59ylmUfetqJFaA1fpZWvJ1KRn065kuSk6sirBB8URUFSioaEorKWtx6XtoVpkolY4NMxdTvUCZfJc2S5rxyyS75zCj5BFaz61Ic9iYHdo/Biiv482fr/59ZyJBsEw6QW6/Mv7v1lBDHD/B0a1quDuYO7vF9YvFNeHAmINSl148t+CqHiaVM2DowL6FQz/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
work is dropped.  It sets the bit before checking isolation and
schedule_drain_work() checks isolation and queues in a separate RCU
critical section, so housekeeping_update()'s synchronize_rcu() can
race the second check.

drain_local_stock() only clears the bit for work that ran, so the bit
remains set and the stock is never drained again.

Patch 1 extracts the stock drain predicates into helpers.

Patch 2 reorganizes the drain_all_stock() loop, reducing nesting,
splitting out local vs remote cpu handling, and skipping everything
on isolated cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Link: https://sashiko.dev/#/patchset/20260827124211.3b94b103@fangorn

Rik van Riel (2):
  mm/memcontrol: extract stock drain predicates into helpers
  mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus

 mm/memcontrol.c | 61 ++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--
2.55.0

