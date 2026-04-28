Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AB3FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5736B008C; Tue, 28 Apr 2026 11:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C826B0092; Tue, 28 Apr 2026 11:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A936D6B0093; Tue, 28 Apr 2026 11:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 946906B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:08:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BE6440360
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:08:30 +0000 (UTC)
X-FDA: 84708295980.28.BF36F61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78D3012000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:08:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXGaUKMN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777388908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=76yJM+wXEC2d5mRwOQlxYDZA3nH75Li/mgrd9t5SYk0=;
	b=Ng/eBRQbL+ob9AMXhDm3iJJJpUv9eMswlntnovMxYMTGG1hlIlr/CEjRdUWR+Szd0Mmuto
	PXB7ENaIWZmIsOul/Y6/urGVB28amxxhq5r4/HigkFvhNCxlfbnBmeMF2xSRjQbqQZGr9i
	ck0dfrpsPProk8fMLKQ1PLyImfAYZGo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXGaUKMN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777388908; a=rsa-sha256;
	cv=none;
	b=gwd68oSahgNxyVEixbuUkWgMdSlpLlRc8ggtvg/nl9NTiADfA63ug06zmyAM6DuUY1b2Z4
	hMyf3jy0XT13raxFCENfXFxmuajjnpg+KRsa9fDR3/PxKqJvNiYrFsXBagpHREz8lD1usF
	CyzRrHGVtb98yOy5ZBZJuQZQg1y6KaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D21C561338
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC8C2BCB5;
	Tue, 28 Apr 2026 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777388907;
	bh=4quu3osxb83SGLE9dYlpfao+/2xbl3i6IE5Aw78wfNQ=;
	h=From:To:Cc:Subject:Date:From;
	b=nXGaUKMNugVVxGYsvvYisN7aRNxQKQ/DSP9jO2aU8rjWLXBpYwWGeLEHl80+HX1vs
	 ghqDgy1W+Xj7t0TGwiv39u6wbInBDy5UGeg3VK6Oh4y24L/V2V4lm+/3QY8Iv5KBMf
	 8HEjW18gwWPgwSk4BCb64WAkhHSExoINHrpw0x/kQ03UWW33KLof79rtj5RN/Cst0c
	 bCTmorQH5omvsmJ5nCOAcpB0SV99SV7qLne7K8uRmVeobcsu1+/0myb0lqFm9+JfOd
	 a5M7jisClT6D4Wedoxnby7wYmEbLWfcpbaxr3VGNYwwtflg+47bPP0+7w2tuNOJUys
	 3EEqFcbvnxF5A==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Release News Letter v7.0-rc1..v7.1-rc1
Date: Tue, 28 Apr 2026 08:08:17 -0700
Message-ID: <20260428150817.125575-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s5wcg81cjrw9c6fy7dh8y4y7qge4irp8
X-Rspamd-Queue-Id: 78D3012000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777388908-434650
X-HE-Meta: U2FsdGVkX19s7yDINRlHPSSZBihyLILm7eId+qRjZFvcn5dDU1durnpLGguRoQvZzUKyTHdIMvCxYO7EMm5KIOPvaQsmZQdxW+El/XeGA5Ne8ut5oV0c/kgLBoLBxD4YxtBVdtoPA5cCqKwqd72Fau/zmfaujI5G8qz5bM0CCzKSiJTaBAhNvs1Z6U4Pdy0S6+trTNS69GiBfOFLLIfUe09CeqHp5kx25Ah7TC8hQSFE4tjXLRJv/znMTufnSZ/naF2DKJTKEk6p74RlaBzdkyDNCt6rfM4ARIE9d6Huk8PieLehI4XGK2pl4jPwOcJdZqe+eoEMIqcli/zTWiwZMpDjpAKBazi2ANS2Suez3zuggmvqPljH05SOzJ5sV5q4JoZMitya5fhBjRYuJRuAYqMOmtg7fZge0B3Lfy1r/u4HzdGoHvdy9SP2+PSlKe4ip32RaXo2rIwuIzbyhUo2NDTUtqFhW3+APHZtRm21qnNzLFCs9HKUqVsbTW0KBvQJOVztOaopZAA2w2uN3R3wFuBkJn8T+oikBpnIge8VrgRsxfOYLYqOMpq0LxkPVvhwflBLB9+wT+e1NVUnzmpJ+oq0sHWdTL094hjWajrfF20HVgWCIhXyf9yHTEkW2+z+Im85Many9xZ7romhDwuDcWOkEeJcOJSZ4opPXiuyfNSz7MDcjkSQ6vSycBX5lswZI4zvXbcQ13TiCg/bSERxfY7gvOUeYD6+kNKjk+qqlf5NUSMdlvqCaEPMJeLTcd91zR64Hucmhi9ZNOT5c0mZRG/k7ClTfgWAA8HdxUZ2M/UR2tGC3N7221stvgFo1t3MVltZvfDdMKJH02vqpcmB5fN1InCtcJCmGL2at/q/Sliil2bp5T/ffBeiEkqkpp/fxDF3cgkmtGT+futzSbu5wMPOb8A50xMMe33yEgm+40RPiPGwAkfvpx+7fx9aPqfbsVJU4HIhAxRn9VsQ2Mu
 4Cf3gfAb
 gZ5IFFy7zdUpShWBRk5lYEfIVujgj5cwlJsyFUN7OJnW+YcskcXdsBGk1wKw6YA5ngKTUrG+ag9MzMdCWAIq8Li5kje8d2d8/1CCi64I+9c8GqEQKfb7AWBwiCK9cUyVr5FDmOzzL9CUOyzy2OtVHTp8OxOZYfD6RdvZYznPiUmo7OFF55/EWlRNI+3Ezi2yWKctQZGGWzIfTOn9l/z2Kw9pE5csd7HBx3NhEQvrfQr8EzIX8tAzHvSxgoucavogIhDZjPNHJT/2eRQheCrN0p4xRkr5+KT3orJCUelKrKyxzlyZY4eO6BRGTMY2DsNp3Yrq9DOGds4BpQXlMWhyZPp6vtC2Zwa609Sg0p2BBQDAqic1nicip4ugei2d83DjL2WgyZa3NZ0J+wY7w4Qqi7UVkwitdD17I7miltLxxbM/4bg9ZFFpnG1qcEvc3WYvyCl8ahYdNnVcuvUKFVyk5aMIqqAcP5yel1ideqYDwupUw1TDpOOiAZrFEGUwyzGtOLmhTmSKwvJgHlPfZdUHYjIK27ypbJnk3hbcXNlgo04bL6gwkpE/zSxFtKdOSkFwgWu1DIKFfiBJ/r7su9N5SD1dfF1AcyCES3rHRblyErrZw6KsE85oeMtrAycpeTkELP+Ps3CUoYrhHs2+RxFCvanTe6U8QGOH13ToSy0T5Z1Gk9qthrT2xxsin+bg/t9mJBDFpa5uH3hNgarbTpIVKIlcDbNFEzMTrtim7a2H6CzHHsc6X18Hy5twV5Vhf0/2eXeDG7GWu4/CqvqpE4Rq7IM5eL06xEHH1UUDYsZQn8Detof36XUi1LKTHwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello community,


This news letter covers DAMON features that landed on the mainline, and misc
events that were interesting to me that happened in v7.0-rc1..v7.1-rc1 time
period (2026-02-22..2026-04.26).

The news letter covering the previous release cycle (v6.19-rc1..v7.0-rc1) is
also available [1].

Changes Landed On v7.0
======================

All changes that were landed on v7.0-rc1 have successfully landed on v7.0.
Read the news letter for v7.0-rc1 [1] for the list of changes.

Changes Landed For v7.1
=======================

During the 7.1-rc1 merge window, 67 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
user impacts.

New Features
------------

In the merge window, below user-visible new features are added.

    commit 8719c59c4b928: Patch series "mm/damon: support multiple goal-based quota tuning algorithms".
    commit c63067e8b0849: Patch series "mm/damon: support addr_unit on default monitoring targets for modules".

The first series extends DAMOS quota auto-tuning to allow users select the
tuning algorithms.  Together with the extension, a new tuning algorithm, namely
temporal, is introduced.  The new algorithm is expected to be useful for
user-space control based deterministic DAMOS utilization.

The second series extends the support of 32 bit machines with physical address
extensions for all DAMON modules.

Internal Improvements
---------------------

Below two significant internal implementation improvements also landed.

    commit e7e1a26b8ddf0: Patch series "mm/damon/core: improve DAMOS quota efficiency for core layer filters".
    commit b1029f29eb1d5: Patch series "mm/damon: strictly respect min_nr_regions".

The first series makes the core layer DAMOS filters be more practical.  Due to
the impracticality, complex DAMOS use cases were recommended to use multiple
DAMON contexts as workaround.  With the series, the workarounds will hopefully
no longer be required.

The second series makes min_nr_regions parameters strictly respected.  This is
expected to be useful for more deterministic fixed granularity monitoring.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

Number of DAMON Commits
-----------------------

Nine DAMON hotfixes have landed on 7.0.

    $ git log v7.0-rc1..v7.0 --oneline --no-merges -- \
	    mm/damon include/linux/damon.h Documentation/mm/damon/ \
	    Documentation/admin-guide/mm/damon/ include/trace/events/damon.h \
	    samples/damon/ tools/testing/selftests/damon | wc -l
    9

Sixty seven DAMON changes have landed on 7.1-rc1 during the merge window.

    $ git log v7.0..v7.1-rc1 --oneline --no-merges -- \
	    mm/damon include/linux/damon.h Documentation/mm/damon/ \
	    Documentation/admin-guide/mm/damon/ include/trace/events/damon.h \
	    samples/damon/ tools/testing/selftests/damon | wc -l
    67

The numbers were 7 and 66 for v6.19-rc1..v6.19 and v6.19..v7.0-rc1.

Contributors
------------

In the time period, eight people made 73 grateful DAMON commits on the Linux
mainline.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since 2026-02-22 --until 2026-04-26
    1. SeongJae Park <sj@kernel.org>: 58 commits
    2. Josh Law <objecting@objecting.org>: 7 commits
    3. Liew Rui Yan <aethernet65535@gmail.com>: 2 commits
    4. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 2 commits
    5. Jackie Liu <liuyun01@kylinos.cn>: 1 commits
    6. Vineeth Pillai (Google) <vineeth@bitbyteword.org>: 1 commits
    7. qinyu <qin.yuA@h3c.com>: 1 commits
    8. Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>: 1 commits
    # 8 authors, 73 commits in total

The last line was "12 authors, 75 commits in total" for v6.19-rc1..v7.0-rc1 [1]
period.  The number of contributors has bit decreased, while the number of
commits has nearly not changed.

DAMON user-space tool (damo) also got a significant amount of changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2026-02-22 --until 2026-04-26
    1. SeongJae Park <sj@kernel.org>: 123 commits
    # 1 authors, 123 commits in total

The last line was "2 authors, 337 commits in total" for v6.19-rc1..v7.0-rc1 [1]
period.  It means still a high number of changes are made for the user-space
tool, but the number has significantly reduced in this release cycle.  I think
that's mainly because I was busy for hkml-Sashiko integration, Sashiko-found
issues and LSF/MM/BPF preparation.

Mailing List Traffic
--------------------

DAMON mailing list was quite busy.

    $ hkml list damon --since v7.0-rc1 --until v7.1-rc1 --collapse \
            --stat_only --stdout
    # stat for total mails
    # 1098 mails, 152 threads, 147 new threads
    # 450 patches, 129 series

The traffic for the last release period was like below.

    $ hkml list damon --since v6.19-rc1 --until v7.0-rc1 --collapse \
            --stat_only --stdout
    # stat for total mails
    # 440 mails, 111 threads, 72 new threads
    # 223 patches, 43 series

While the number of landed commits for the last two release cycle were similar,
the traffic has significantly increased compared to the previous release cycle.
I suspect Sashiko might have made the impact.

Events
======

Listing a few events that happened in the last release cycle, and I think
noteworthy for DAMON community.

Sashiko
-------

In the middle of the last release cycle, Google-developed AI review system
Sashiko has announced [6].  It turned out to be useful for not only gating new
bugs but also for finding existing bugs.  As a result, more than 10 fixes for
DAMON are made.

    $ git log --author sj@kernel.org --grep "discovered" | grep "ashiko"
        The issue was discovered [1] by Sashiko.
        The issue was discovered [1] by Sashiko.
        The issue was discovered [1] by Sashiko.
        The issue was discovered by sashiko [1].
        The issue was discovered [1] by sashiko.
        The issue was discovered in [1] by sashiko.
        The issue was discovered [1,2] by sashiko.
        The issue was discovered in [1] by sashiko.
        The issue was discovered [1] by sashiko.
        The issue was discovered [1] by sashiko.
        This issue is discovered by sashiko [1].

Continued DAMON Development From Contributors
---------------------------------------------

Ravi Jonnalagadda from Micron continued their node_eligible_mem_bp DAMOS quota
goal development.  By the time of v7.1-rc1 release, Ravi posted v8 [7] of the
patch.  It looks good and almost ready to be landed to me.  This work also
inspired the multiple quota tuning algorithm series that landed for 7.1-rc1.

Asier Gutierrez from Huawei continued their work for making DAMOS more useful
for THP.  As a result, Asier made DAMOS_COLLAPSE patch [8] merged in the
damon/next tree.  Hopefully this will be landed on the mainline for 7.2-rc1.

Akinobu Mita continued their work for extending DAMON with perf events for
lightweight fine and fixed granularity monitoring.  By the time of v7.1-rc1
release, Akinobu posted RFC v3 [9] of the patch series.  It is currently
blocked for the general data attributes monitoring interface [10] that I'm
working on.  Hopefully the data attributes monitoring interface will soon be
stabilized and Akinobu's work will be unblocked.  This work also inspired the
strict min_nr_regions respect series that landed for 7.1-rc1.

Liew Rui Yan started contributing patches to DAMON.  It resulted in two
hotfixes being merged into the mainline, and a few more patches that queued
into damon/next aiming 7.2-rc1 merge.

DAMON at LSF/MM/BPF
-------------------

In addition to the two DAMON topics [11,12] for LSF/MM/BPF that were proposed
in the last release cycle, I proposed one more topic [13] in the last release
cycle.  Thankfully all three topics are accepted and scheduled [14] for an one
hour session.

References
----------

[1] 7.0-rc1 news:
    https://lore.kernel.org/all/20260228194805.97228-1-sj@kernel.org/
[2] MM PR for 7.1-rc1:
     https://lore.kernel.org/20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org/
[3] Second MM PR for 7.1-rc1:
     https://lore.kernel.org/20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org/
[4] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py
[5] hkml: https://github.com/hackermail
[6] Sashiko announcement:
    https://lore.kernel.org/all/7ia4o6kmpj5s.fsf@castle.c.googlers.com/
[7] node_eligible_mem_bp v8:
    https://lore.kernel.org/20260426003245.2687-1-ravis.opensrc@gmail.com
[8] DAMOS_COLLAPSE:
    https://lore.kernel.org/20260409150128.1566835-1-gutierrez.asier@huawei-partners.com/
[9] perf events based DAMON extension:
    https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com/
[10] Data Attributes Monitoring:
     https://lore.kernel.org/20260426205222.93895-1-sj@kernel.org/
[11] LSF/MM/BPF topic for access-aware THP:
     https://lore.kernel.org/20260211022845.68865-1-sj@kernel.org/
[12] LSF/MM/BPF topic for allowing NUMA hinting faults to DAMON:
     https://lore.kernel.org/20260218054320.4570-1-sj@kernel.org/
[13] LSF/MM/BPF topic for DAMON updates:
     https://lore.kernel.org/20260307210250.204245-1-sj@kernel.org/
[14] LSF/MM/BPF schedule:
     https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899

