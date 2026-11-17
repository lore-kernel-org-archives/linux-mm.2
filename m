Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7112F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TvGEZzEH
Received: by kanga.kvack.org (Postfix)
	id 727856B05B1; Mon, 16 Nov 2026 21:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8656B05B2; Mon, 16 Nov 2026 21:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7846B05B3; Mon, 16 Nov 2026 21:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40E816B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:29:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB44F402B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:29:55 +0000 (UTC)
X-FDA: 85443030750.27.DB9B207
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 389DF140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:29:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvGEZzEH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794882594;
	b=4xSqp81Nr/hy8lj/QSqlQur9qj/ZXZUuJLdTECLrmfPLCLYCB3fTI+YBgyZovmwxjxsvEF
	dWbL2XiSt+0L3N81VbjZLFGTAfYU3/rU4g6vPZDGkKij6jMg62BHAxyFFiroHiGQMBrs43
	3yJbHSgci/Rgy9vM/hWeTc8YnHf60Bk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvGEZzEH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794882594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1NnY1aUEnyj0N2YV2VpV/7pu0yFFtNIfVI4q/uNQmk=;
	b=LfS4i75173AhgFhADHttgyqFh6KF1z7reR41V4mpur4Ftpmz61qROsIsI4LZV3zHOD/4/4
	x06eVerNg8yUdPk7fnNTegRBtk4YXZ1MqRjEA51P2AeKkrxcBcZKwHbPud+7Htt8KiaMiP
	qCT3kSFthgG2v858+kAce+4/Y4w/fGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B76062657;
	Tue, 17 Nov 2026 02:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4771F000C4;
	Tue, 17 Nov 2026 02:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882592;
	bh=I1NnY1aUEnyj0N2YV2VpV/7pu0yFFtNIfVI4q/uNQmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvGEZzEHU+YK7myU8eG1QIV0P3CPEqijBPwbgCoeq+/r77R9DFec4r9ST/FRdfWlv
	 YR50U7jG2ZOfEnrjP/ZJLCxAn7LevmeUv4oDlhu7ULa5GdRl1KrQ1ZQhZNXuPl8oDQ
	 LbJD9tX2nTmkRwP8PKKth6dC9/X+oFsaoH+R6qNm6UlYxWp5Ejk7OQiOAGDwGiddi3
	 PP49WS4fIBgufNuEXlrgQjZ62TL/kZNZwEWxovVvquKTaN8IrNtWkTvZD9V9OiXbrU
	 UKcHw9pzKHCDWwpjnhuxhJdP42rv+j48F2eHTBIJs9r04Z09tIB2pRUIbSIIQQFPyj
	 nDbp5EpwAm8RA==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 5/6] Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
Date: Mon, 16 Nov 2026 18:29:43 -0800
Message-ID: <20261117022945.110648-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-5-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: teucpig5iaat8tucjigd1braorc8mckx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 389DF140003
X-HE-Tag: 1794882594-261780
X-HE-Meta: U2FsdGVkX1+W3LFb5ZForip+ZoEeNkna9HuUA5TmdX05lYJlOwBbIwYGaCNRf93gn1kGNSHVu5eNoYQ9Uk7hxQ1Hif9jwflFTOZjH6LL6A7L5RpcvnCVJKXDmoiSb3bRgzUfeLvipJcp34nan7p1W92onGGKkHhcwGKMojgQAwRfw3V9j4T0OLP02Bg27XJjiNvBmJjCSAdIr7zJBxx0w/ZuohNgajz+5J2lix9s1NI8WBRIdu4ecaWSixJM8inQQsOjtNx0knCHVbuTEFoy6RBVKpSCnyJ4vUpqkFzMh2/MzTBbmRNoBBNr9lUbE+UnZFJmbaJp2LveuBOQKfNrwwcJvdSno3iM5v/gdce0BgrxX++bV1PCGT+qSqqvcAz2fiZQfGsk5QbZEniCxF9S+YYt1p86/6q/5GZnHx3WfW3WN5vtrJtYjzlBBZgwPLjwdDsexkV/OSsRK0pY/XSDpKly57TdGReld/qz5Ug0nMB5H/J+rPMZoWKTqHg0CPV6ytE2DuALcOxXV7kbUa5QYpeDxSipqmrVHIheLJMBjf7zb6SU7oTuLXb30LDqMgSWTmYKuo/mysmhB863Ai5YHuJjGZrWvhlsMjY5EXBBYcTlH44OJJ4UaQBbYFo6H0xGnVExqktRHw9CipseB0Nvt5Mf+GDyqgqJHpAGoI+Zd6qWNEO/bZsi4I3suySvo9CvxADq3DPW0hHEZ5hKxWG0ftwZHD7LXLyRriXK6wlXZLRqhMGetYJOZVV/8HX/hSzeB5H4i1dTHSaZ7LhKM6M4YHoTX6++tsfdxkJvMT9GbaX5HnjyYp1N/FVhXyFGP0pI8qxNMF20XgppAalUFAh5rfHkJ427ERLtzoAmLai5NagNSGoKkThqm9It0a1j55sIEN7Cf950eJSdJWQW+1sd/e81UaHPW1FSCWw1TxMfSyG+y9CSqJTdgsXihhf7hTAK1xCBmkBPY3eHP4SKp+b
 qplQqt3R
 3oePTzNQf9BnOXfTeR5z/FNbyxOgVIrBuu9HF5sf+Psi5mP2BSlXouGudhJUVs1+2oEwJ1469qN2zx/Zque1l9FwvXMDNkKENMrTV2sipdATosMJ8zEeSrEz3bRJvYYyhZ4RhXkPyHttestWJlSPKmucRiqtTVHKfRoOha6wWAQxU5oguT6V6QwGdTgOT95jLiBw0LXf4wsNYtbwl6MJ/Fa+kvFQu3i/NJOwzGtwGsSsCi0QfZswUpF5qN9K4c0LNlErKu2nd9D9OMMC1iYIk01xBVYfYc0W1ObGkSWOjK7nXgBtlGcjvGMMqdutQ1A6DKJrEgMx0t6DIuKEio9w2G6gL3yMZ588cWSMrhjF2gb4NHLA6Ih6RiM07SB8CVIz2Hv2NvWjaFJSmJT1wpdKbPUBNzu8wjAUFGb5CvQ6c1JLtXNKAUS8XGjZKWfrRKsnU3/NMXus9RcM23NsHHOxLMR0kx0axzG2Tz2ONko5sl/CaT9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:08 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON usage document for the newly added DAMOS stat file,
> sz_ops_filter_passed_last.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
> ---
>  Documentation/admin-guide/mm/damon/usage.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> index 6093b1c8fbfd..c0101a68a033 100644
> --- a/Documentation/admin-guide/mm/damon/usage.rst
> +++ b/Documentation/admin-guide/mm/damon/usage.rst
> @@ -105,7 +105,7 @@ comma (",").
>      │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
>      │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
>      │ │ │ │ │ │ │ │ 0/id,weight
> -    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
> +    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,max_nr_snapshots

Too long line.  Could we wrap the line together?  E.g.,

'''
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -108,7 +108,10 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,max_nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,
+    │ │ │ │ │ │ │     nr_applied,sz_applied,sz_ops_filter_passed,
+    │ │ │ │ │ │ │     sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,
+    │ │ │ │ │ │ │     max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
'''

Other than this,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

