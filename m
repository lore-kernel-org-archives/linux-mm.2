Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13492CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1EB6B0088; Mon, 12 Oct 2026 04:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C076B008A; Mon, 12 Oct 2026 04:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44056B008C; Mon, 12 Oct 2026 04:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9987E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:18:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A3F01C43B7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:18:01 +0000 (UTC)
X-FDA: 85313271162.16.70F3C02
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13FE814000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:17:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=MJ1b1Rfi;
	spf=pass (imf09.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791793079;
	b=FCVDI+YfqQnxXrcRbOO5GOMSKWA/hz1GDv3HErOJfU5Pr9g86OYghjpa7/hr8GnqOwEs//
	ICOJqGadER2Dn2jj1dHpZtI7WNvRMpPX0bNm25d124sKbo25kHR4YSJaskop06xCfO296m
	bycyvqfQrfsOTiUYzAUVviqLUNmCXrQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=MJ1b1Rfi;
	spf=pass (imf09.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
	b=ST9FFZCp4T6U7Pc4Ujy9UkRU2KF0kMki26105C9PxoQKBJzvtMWpsndO5KGlq2UOoJUXFi
	4C8m1pCdbYoHJnF+16j1na4pM+RUMhh8rirzSEyxscsleQEeqMeFxXatmLyhjKAjt+YV12
	A7v0dn2dnrsI5Y+jGP40bnunYFsuCnE=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33c2520ad38so3647913eec.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 01:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791793078; cv=none;
        d=google.com; s=arc-20260327;
        b=EQHB2gyZ4myMeSkj2jSu2PtWGzXbpLaRMWNlQnbkh1xlqZbsykTe6pxwlKvQeNs5ql
         XapIYZzUULlSgLhV/g4jx24dpIftKIdCbrCYYZHE2SThPgbbWoY5NSGFULR+ZYOXUmak
         Oq2tG34+Gb6ULBWdJnckMXKwLeFAXH0ocMwUxyHpPdScVH8DNuGFb9ZsdyeWm+xmzlMR
         8rjalGrpKpi9sQ117X3QEc2/r720AqmxZg155P/BLCNeu7zPCLRXer8u2u4uTh+/Ki2N
         CxUFSwki4WGjEz2IyewD06/wJxYPxjmGAu/cfKmEzUB93cYi3fPp4JsVUja0F/r8XEnq
         KE6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        fh=+Eyhl9Etkq29aBgDpCYqqrYqlftMMiTg54l4zJq2ok4=;
        b=ca3Qh74HDWPoOqsgbfwh4gCnA79Rjss+3yleBw4IRXhp0jD2Yz+sPgYSAcOv8AFpUH
         /hFxcPwd/S7M0VanN9ZRnaB93L3p5fjs9TXyU09M1U+5OBlUtqKi03pMscyFI5IjTTf6
         BrEfUK2ci0mpqN6dIDI4PYoF1AThEYMDeIVbhd4R9zwcB8iTYrmILmMqbjZbTmIR8b/I
         H4F8N4EUNhx2BHp+Mcs5k5YTSYtN7LoFSrOOI+MTLCwPecEG1Ynw8XzMdTtYylj+l++K
         AcBeCmBfw+04wDwDqt//jAs8aGjw6gLH2ysOTyjJmXZxyimdO7ZJNLTtYxu9Wz/3rIut
         WRgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1791793078; x=1792397878; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        b=MJ1b1RfipTcY2FhvQOU455GwFEYTHmtj60XQAJx1s5bt5LKlUYJiSCtAYH5rB+jJkR
         oPI1l350bQw/oAJRXH/Bz8BxUfL27KJDnrIJrMmibr4EVhNEldpuQKH2Tv4olQz2nfGt
         bDfGUuPJtAOTW8jDHFpLTriZwAyl+5QGCpSNo2w53qNusViiNCz3PPp6OZBoJOXAyMcr
         ts+L1UoS+E7lFlsAQw/EQnDPiL9SBphpp62cTkGCIxiPABTiTGWwPs3YDHb+HtZvs+fh
         MnFpx+RFeezgI532P6c1zl9k6GheekJj7/+JMsp/Ys5c/ke1szETQniMuUO7KDEhHmC+
         Xd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793078; x=1792397878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        b=fDQimTAjH1dnR38LNkOS8Nzii38DbOMzWzqhlFfFRLZlXnP6NoZ9abLRmPu45m2ZrO
         SPtBh/Fzex7qNxroNLdHkkJSoYB7+oSh59xdf+DSBGlQ84MmHPjFSJRPeweFxvtzeJPD
         CXH+mThrgPrhrhqsP+HgNfzHxRVwNM0/74N1onHTSG1l+RT54jrzFD64zNVfpt5L4MzR
         DMvh6gX1glvW2l1k9CvoutfDpKR+bme7+n9UvyXvIb+6JMe22URFBQaujxJckTlS7uSK
         jgumbux6sWTL/4UYJ5i0AWHHO63+04WupkiZqviCrKVmj5TUT87d8WBzfhqjRYipoVpc
         rvvA==
X-Forwarded-Encrypted: i=1; AKwUvByHTB1mktVWT9CdMrE8H8PVDKPkSfkbeISc0S3YkLSRborG2q+hSgpVKTu1rAuE4nV6ImI3OrV7/g==@kvack.org
X-Gm-Message-State: AFq9FYLUNIyausv17DAoRVZ2ofdkctjl9jbOxKbpLrlULYhMv/emHMyF
	x1m/jKKHQ/oSyyZ7yXOdD8N4+8he3bqi2Xoqvml2AcJMvy0z8iIu1WSEPhKTRK7+BEP3JLTQNj2
	Dp0vYhEMbCgl/ZqkfoWcaexO186cBChe2H8DGvCD5aA==
X-Gm-Gg: AYBFou02LFEHU7j001x0FR9hdQWKfqLuAOZPx7RPz+0Nbz4LIkQo0ju3yjvsUl0FISG
	kvRj9RaXzqXHk+poVAPN3v6spVvUuY6fT6zaEZ0KBUIPIEU99VmeHcj0k067laasYECPh27snaL
	fkYfM2io07lGiiQLCXCYb7CUeiipaq5p4pyRv3YZUsCtx4KE4xGHyap5h0u2kT+2Dc6tURgFyvp
	T09zQRW2VmGLBXmiOu2LYNEWbKnelIRm1C//fxexDD0yZFCWnY680eT40JZZJw09NcD0pGP2Pt4
	FLI+oC3+OGTSNDWcPz3Qa6Azk+g+9RZqqmY574lEW95OFlvGnzx4dLc=
X-Received: by 2002:a05:701b:4305:b0:149:d501:b990 with SMTP id
 a92af1059eb24-16a5f3f191dmr9983232c88.25.1791793077611; Mon, 12 Oct 2026
 01:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
In-Reply-To: <aqRXqcynCx88D2QK@linux.dev>
From: Mingyu He <mingyu.he@shopee.com>
Date: Mon, 12 Oct 2026 16:17:46 +0800
X-Gm-Features: AclHuK-_Zx2LzZN02tzISzVWGha4IvMdOMWo2JFUzwRP2aZsF1MCrxc-_yMLwpY
Message-ID: <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1shqizketawn51mbxik6ujcxams48sqf
X-Rspamd-Queue-Id: 13FE814000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791793078-85480
X-HE-Meta: U2FsdGVkX19jrZrxcQYTmTHEve506x87uteOwRELFty9o7KfsejpBlJV8tD1xt+/ZVTmgSEiRUzaUQFpQX97hrmOLTNV+c0rUwxB9QET00OodcGwIy0HoCWkaeNAbGLARVpxlFW2ZEr7NoPni77ZIJj2N925Gb1rlNoC1cDdCT0ema3kYCqm0a7HLJeLj/t2154SJhwnJnB88DWehryajVUKH2DHbv72/0Qu8POmpzT1VJJPB+WxjruOy/iwM8ke0hK7AGmNqKi0wE3YTJcA+raSu6IU9D0OOw4aPiTWJ5jZZaTSzcEvi1sDoIqdBf/RIro9n92Pmid4J2oPIO5dlQN2v7LWc52v0B9wbB+i14awZaW1T/woVmRSf4PSHTas41w1jRFeU41Je60JxVUYlnNjbyZxAMDjjTOHL8xU7v2TN2p0aBK8K1XePICUN0QT7uBM36FQJcBGYWqOLtBWa1m7rbh3T1P8KnT85pqCNOPIpO1ROPCQyNvMKdHDaWabc6D5JfU75SlrvdNQS9awY7nCZ25W3yxxzQ2O0epMpBd1cczMagnNTLyh/8W4WZLOl234kHGMZ/5lu7QGbm1uvNzd/dY7CdtS71pUpSI8LnBpAHaHMS4Xjqo8IDChWDvXzRqB97XIQG/yDqDcAWGXGdDvOKhLoVTV4PJ6gLBoDxalgPfzmfiuZhabcSJ6fMUi1yk1SStIoCHprcKWMSIbkOfjt5UD9+vNx51WjKnnggb3vu2YcpeRIASycmhtZu+zF5XHHTnSOnYUJE5VP548XHKPek1LLBKM44QXX516V6qfETs9yIJgTDjwROU1D54jKgdF6+W8zF3fIAsVzhfSzLbjch4jPIuWGg9TLhwVozR53vqLdj88fJfFueSevmy9Qi7v7JIKJ6VDwxS1pcc9SYDZgFr555k2OsKCsIMv577cUSBzJHOvYW7NzzX9Uls6ENS2qgQuhZg2mRZS3dv
 CwYvZpq4
 NHG9fYIz3mU6LUC1bxKEL2rIExxW4PxR2iulYOPNK7nStXwYAmOVsoEBzPmJMaVi7FNDuar70xtH2b9e9983x36zVn96qDnTtSJGkaAhu3HEoQxDWF3jQWA5ab3Ohur5/xzVo5m+5Ps6oD2RcWncwNP7dMU7H80dxeGuegVdSbZKRDxKNZTd4SwAqH9K61izJiDtYr1Z4a6f2ttQkr5bM53zdivLLsCevkM7UgTBjfmhwVTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

  This came from a reproducible workload with a custom in-kernel consumer,
  not a conjecture or an AI analysis. I uses aggregated file pages statistics to
  decide whether reclamation is needed.

  Tracing showed leaf stats_updates at 6656 while root stayed at 6144
  (the threshold). Further updates stopped at the leaf, and root flush
  requests were skipped.
  In one reclamation check, memcg_page_state(leaf, NR_FILE_PAGES) returned
  about 2.64 GiB from the aggregated statistics. In the same invocation,
  a bpftrace probe sequentially summed the leaf's per-CPU NR_FILE_PAGES
  counters and obtained about 6.58 GiB. This sum was not an atomic snapshot,
  but it exposed a large discrepancy with the value used by the check.

  The periodic flush does restore progress. But issue for this consumer is
  the missed reclamation decisions before that flush, not permanently lost
  accounting.

  Regarding the BPF interface, the implementation in the tree I found is:

  __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
  {
          mem_cgroup_flush_stats(memcg);
  }
  This bpf function still uses memcg_rstat_updated() benethe.
  It doesn't handle the issue.

  I originally called mem_cgroup_flush_stats() before reading the counters.
  After observing this issue, I switched the consumer to css_rstat_flush()
  on the relevant subtree.

  If waiting for the 2 seconds periodic flush is acceptable for this
function even
  under continued updates, I agree there is no need to change it.

  However, the comment in memcg_rstat_updated() states:

          If @memcg is already flushable then all its ancestors are
          flushable as well

  Concurrent counter resets can invalidate that assumption, as the trace
  shows. If the early exit is retained as an acceptable trade-off, could
  we update the comment to acknowledge this and the reliance on a later
  flush to restore progress?

  Thanks,
  Runli

