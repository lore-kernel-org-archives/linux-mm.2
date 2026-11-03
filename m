Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C191606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILFSQTAa
Received: by kanga.kvack.org (Postfix)
	id 9EC606B05B4; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DC06B05B3; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D366B05B7; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4E16B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B182C1A02BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:52 +0000 (UTC)
X-FDA: 85392000624.25.DF75183
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16C4940007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILFSQTAa;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667591;
	b=vAvOtWK4BV0VFN7n/f4jN8xmpO/GOMLS/pYQWPma6enXKuFnZhx1eQJj7K/MXuK9zsLLxw
	h4RLS2AZPHw3O78abQGdkSlDvlG/ItbqPZuBVVXfRU2akpg4+zQPpMRBhi3fXoCfOirPPm
	QyQyJc8SIdmLG+SO4fIDStL+NDk1kcw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILFSQTAa;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAIEk27vq7SBMU3eK04a7ELsfUgkQKJdZcdW3LgEO4Y=;
	b=0tEHMtDXFdQonFhCbGmFyQNfY0TPwg2KzYEf+ULVP0VMF6YWfwPKURQSUhjS2XWDixRXGr
	Wuh621B8hSbnOVcfqzIqNKsv2Wkp9G0uNdX9hwxBC6bRJtnpi5DNYkviurikuNdXAgtDbF
	S5kHgBmhsWkfx0jTQQxF0LQSgy1sius=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 283776022E;
	Tue,  3 Nov 2026 00:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E02F1F0093A;
	Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667589;
	bh=eAIEk27vq7SBMU3eK04a7ELsfUgkQKJdZcdW3LgEO4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILFSQTAaF6kJrx/TYSoWIT/QtO9KF/QFp2Zk8INMjPaYjb2f+UqWTET9sOtVdHKdQ
	 m8TZi2CIjLtn+FhaonI+i17T/s7K09H8tj71lT+I1Mq3hA7A692+pBT5oRytXct5YY
	 +wZT6hXli590DAaPdla5HkprTqm1LdFV9J/4G8f/Z1Cra8pCKyh3FAy76gQiJixkTC
	 vR7if78QAz+tbYCvCeLfpWujf713hFllfnpeAD+d2ndXzjnASNLxfqQHMkQrXGyzTz
	 etgyoOVKLJMp/HIZnuT6wIqfKl1fpgCA/WuaZPueIUHxZdNsB5uoReJXdCKgwt+uWx
	 6Jx/1Qz/yrgxQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/8] Docs/admin-guide/mm/damon/usage: fix grammar
Date: Mon,  2 Nov 2026 16:59:33 -0800
Message-ID: <20261103005940.91432-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dr1k3be7znhotu7qeb3whgbu5ehyz7wp
X-Rspamd-Queue-Id: 16C4940007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793667590-622635
X-HE-Meta: U2FsdGVkX19kINSK5avYijznApMvvlGUNwtYIH25H1Dl22ZgRnG4XKA8KnRgYnIKm56rhj+gPglNuHWSuX+obSFxDQxeJgIIfTlI1HGy4UQZpG7zj0jwo23fW0eqccHKxG8TW2yG0Fdlncjodzx5eKKSrAF/SK0ondGcUFl7JU0rEUOB0QbMK39SbGfQun10M1kOKbJG3fAtIAv5aw9Si0z84us2uC89YKeCaZM82JYsddVUHL3xhgJLFnZnvxz4ndTVyJkDKflLZj+3dPxnVhv01m01LGJOy1KRp27MlbFlbe1gwnh7yeYWHtEh2c8Mmn2d9LYtN+Y6+5V/d9sz0zmJejyGd4csqBg20CkvWxG0yZ320xkiKE0O5kky9C30rZ/e2qgBNqwzF8tr7vWW8jCs13S2gt2PD4c+N6gKqRNVD1IjTfZOw5vMDh65uSgiiChKSPiUKBf7JpgwCIK+oTtVQ2Zwyl/4Xni/332voUFNObxWkdC08twmP7bUAzDTcCbBnAAYAxeJDh40yJFAPG5C5ndfZHdIuKudbIsYhFlVcfrqXNvqn0iPvsIF9xfen4pJhykoG1N7f8Iz7EfjOMvppc1JJqhvzkNwHt/6QmanjWsKSdcb/VKGcKFUdfUAE6rtmHA6SQGo7VvSf0Mx7ciuMUG05JmLlEXhYolDW2njG5hLWM15cUtVJpVKJwnSFXKQy/S6jujXhL+ZVSmU9XOtiwGW8evPZH6yjN9sLlP2dXrCVNdiXB3E2mrU9YniKxJH/jxgWJHfx8u6rmY3vZx9zhekZzwE0KbxS1nVotjGIykjwyF2mOX54oH222kyugBMMJ/YMGjmaKt9r6Ne/MM4xaj5uaATUZlyoo8L8JC4byPKd44cVLOJrVE52Gfx9WH85F01Z0XJlvM40Q1isFp366yXTHZs0niRRvMzJs5YLpq8TJV2drmJ/VnZ+OhDk+Y4liyTO6Z3tik0pe2
 nQhGE8QQ
 WQcmDsQ08wDCD7RRwl77R3Fdtk6I8/MoTFNGY8doIkl/+mCzyZGto3Tw91MT9RXpfeFNwR8SzcPCPjjFEJcif7NoAUUTkNrnsxQArcziwkw7/s5z6WNL5nF580K6ZnGkOifNsrh5a48z35+UZ8p0vqJRhkS2npXufwyA6D1hp74luEI1UGKuUkB5R1DKScDJnkqjwgyhnnFeGcJnu9O8dxi1A4dL1QC4WkP93f9Yw/ox+C1MWHcQwsOycRfQzqUxo4PfH1cQqZh2ucjklTxFADPKGvABaZlGo9iVWChWbmr1LepH8ZbFcDh7ibwYY/OdnRUxJpz5D0GbLbriV0+OkzjCs25kyMWAKju/Zv8dyNzxCCony1TXr2xW8/OqgWh5ntMh/INRrbqQrQ5nVvGmsKG/Sd/vU4zSZbVtr/MtCF64jGZ+NMkmP4OuJ3Dwq5mg0RzT9lcEQzKq5oJHddID/XpVpklGbS18AGQfTQ4h6LLfDynzKK0PnlzBQjD/o9lpDc5usmqhwim998ijMG8MIX8PxE779n+KzKpGw58lJr+dislg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

Fix a handful of grammar mistakes in the usage doc, mostly
subject-verb agreement and a missing or extra "be".  Also turn "Below
commands applies" into "The commands below apply", which I think reads
better.  Rewrap where the lines got too long.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 31 ++++++++++----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bd687d89ea4c0..cc7465251bb6f 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -23,7 +23,7 @@ DAMON provides below interfaces for different users.
   want more optimized use of DAMON.  Using this, users can use DAMON’s major
   features by reading from and writing to special sysfs files.  Therefore,
   you can write and use your personalized DAMON sysfs wrapper programs that
-  reads/writes the sysfs files instead of you.  The `DAMON user space tool
+  read/write the sysfs files instead of you.  The `DAMON user space tool
   <https://github.com/damonitor/damo>`_ is one example of such programs.
 - *Kernel Space Programming Interface.*
   :doc:`This </mm/damon/api>` is for kernel space programmers.  Using this,
@@ -155,7 +155,7 @@ Users can write below commands for the kdamond to the ``state`` file.
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also
   ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
@@ -250,7 +250,7 @@ writing to and reading from the files.
 
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
-controls the monitoring overhead, exist.  You can set and get the values by
+control the monitoring overhead, exist.  You can set and get the values by
 writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
@@ -268,7 +268,7 @@ Under the directory, four files for the auto-tuning control, namely
 Please refer to  the :ref:`design document of the feature
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
-directory shows and updates the tuning parameters that described in the
+directory shows and updates the tuning parameters that are described in the
 :ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
@@ -496,8 +496,8 @@ Among the multiple feedback, the best one is used.
 Each goal directory contains six files, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
 Users can set and get the six parameters for the quota auto-tuning goals that
-specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
-writing to and reading from each of the files.  Because the kernel does not
+are specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>`
+by writing to and reading from each of the files.  Because the kernel does not
 update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
@@ -535,8 +535,9 @@ DAMON-based operation scheme.
 ``core_filters`` and ``ops_filters`` directories are for the filters handled by
 the DAMON core layer and operations set layer, respectively.  ``filters``
 directory can be used for installing filters regardless of their handled
-layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
-installed before those of ``filters``.  All three directories have same files.
+layers.  Filters that are requested by ``core_filters`` and ``ops_filters`` will
+be installed before those of ``filters``.  All three directories have same
+files.
 
 Use of ``filters`` directory can make filters evaluation orders confusing to
 expect.  For this reason, ``filters`` directory is deprecated.  It is still
@@ -612,16 +613,16 @@ Users can write and read the identifier of the destination to ``id`` file.
 For ``DAMOS_MIGRATE_{HOT,COLD}`` actions, the migrate destination node's node
 id should be written to ``id`` file.  Users can write and read the weight of
 the destination among the given destinations to the ``weight`` file.  The
-weight can be an arbitrary integer.  When DAMOS apply the action to each entity
-of the memory region, it will select the destination of the action based on the
-relative weights of the destinations.
+weight can be an arbitrary integer.  When DAMOS applies the action to each
+entity of the memory region, it will select the destination of the action based
+on the relative weights of the destinations.
 
 .. _sysfs_schemes_stats:
 
 schemes/<N>/stats/
 ------------------
 
-DAMON counts statistics for each scheme.  This statistics can be used for
+DAMON counts statistics for each scheme.  These statistics can be used for
 online analysis or tuning of the schemes.  Refer to :ref:`design doc
 <damon_design_damos_stat>` for more details about the stats.
 
@@ -680,15 +681,15 @@ tried_regions/<N>/probes/
 -------------------------
 
 In each region directory, one directory (``probes``) also exists.  In the
-directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
-of installed probes.  In each number-named directory, a file (``hits``) exist.
+directory, subdirectories named ``0`` to ``N-1`` exist.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exists.
 Reading the file shows the number of data attributes monitoring probe-hit
 positive samples of the region.
 
 Example
 ~~~~~~~
 
-Below commands applies a scheme saying "If a memory region of size in [4KiB,
+The commands below apply a scheme saying "If a memory region of size in [4KiB,
 8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
 interval in [10, 20], page out the region.  For the paging out, use only up to
 10ms per second, and also don't page out more than 1GiB per second.  Under the
-- 
2.47.3

