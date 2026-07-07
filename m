Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC77FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 00:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DAC6B009D; Mon,  6 Jul 2026 20:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDBD6B009E; Mon,  6 Jul 2026 20:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3706B009F; Mon,  6 Jul 2026 20:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E80586B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:14:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40F93120277
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:14:01 +0000 (UTC)
X-FDA: 84960057882.16.56E6419
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AD5FF20004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:13:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfisRpmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783383239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eB1zO+hEcVPqicULA2t7Fk+v6ErU6JNrcgHBtzJJkzs=;
	b=DfmG7UqyE2px7vpHrwH8XiUPcHBEljiFiiuFsw8Rw01KGYRbnvLTD8clRT/vIvnaVZt5Ty
	G5k80AUHV83tDUf2/teJ4nRnwQ0fEl+oSkZ1bvaTg/Xl41em3MZ1zHkqA0ZOlAKEQcKLxS
	nxkdcG1Val+rgqCigVIuM+n/CnxeVM8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfisRpmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783383239;
	b=Q1B09IJ8k65qF+c+AESX0SX1xit1prMKRA13ICNl0sAOqDWf6ZCEH31BS6vF9PXo86hTR6
	90J++vJmpsaFl8UZn5kS0HnH9FyTFz0jw8lJ7RJ6Af3BFu+avAgWPnrCh9M6dxZ7ASKGZb
	9TmKfQ+CuEd4GWk9KrGRkUQEMNKWBc8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB74A417CE;
	Tue,  7 Jul 2026 00:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4061F000E9;
	Tue,  7 Jul 2026 00:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783383238;
	bh=eB1zO+hEcVPqicULA2t7Fk+v6ErU6JNrcgHBtzJJkzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfisRpmL2Q7w5vhJODKT4L8MN52r2hKZK1CUd5JBD+iHnkyyQ5OhUgtVxtUeEg9lB
	 eNxlm7zM36O9+peBNmx2jkzYsEVdlBRHCfLrIgKRpICoHXwykEeEh8hOEm9BrRBFYV
	 o2OUt+qNG7f6ak+9jD8DgsavWkBS3gZs9X+WBIk3e5iQ53XnmJd7+ENMUET9bp69qs
	 cyjgB1Rt5a/0BQfxxMrKkWX+XW/D2oQjJXAnR75wh3q8zqOeFqiHRtcAZlYytGCg/o
	 sjMu98VOEpUkOyXfnviw9v4NUmS3Ic2lpdJ0rsLD0Bfoned6QsYjD1y4JHy9C5VsDc
	 7MpJqJeD2tHrw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1.1 00/16] mm/damon: introduce data attributes only monitoring
Date: Mon,  6 Jul 2026 17:13:51 -0700
Message-ID: <20260707001353.98054-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD5FF20004
X-Stat-Signature: b6e61zox89oux7m6hce6u9k38bnpkffe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783383239-499147
X-HE-Meta: U2FsdGVkX1+hQaywJz56L+Mcjn3zEeRCNfxq2ib8Nz9WJ3/yMpIAtCgfQJYY8BH72B20QdC3X8nh1WnjD/eKDPKqlsjyizXO/AoZU8XUAu6qwtJfrWynynugWwygyX0wbyTzODw1JV+hfm8NvrOxi2LRDyk8R6H7p/HV96P9S/upWSTWlT2vgtAiV51X+dBqdQeHP2/JRrMKP60uo3C+cla4EtARJCqL8sALYDmddsVDM8hkAQCPMlIpbefDxErq+8/4JEtsU0SPUlr/nhaM3E3wTTBqmfUREFoHOutn6ELkIRjKLtvxEqTPKsf2ABXbz4uqpt3JMauebl8gz5/4iZHPkYgnjCxQO0uu7x3ZpRgxTXaNPHZ0JaNvcBUGJa58BZeEGRJO77rU+ncRGz9ZSSVcILD8ZZQDcJfmHOLytRCoRQWlhViLi03s57nd2mrtWVvjuM1xJ4ip4BW55GvsNd2ndX2A+W0Ma1Pjqw4sjmikvLaaIM/tlUC+boa8pBEz7L9V+2CVkuGN7cd2+vBUD0K0hkwpPPyuUa41QQZEEtpS7GgskX+zruHV+8cB40yoXaQQ1jS6+0mP01q4Bl1IAWcvoQ4UXUeb4nuh3utTEvHDktla2687H0V90uRjZuaKX+LZfjwYq6cWR/QqPTmtLhAS7pzQ8mprDqKF71OzlaV7ahl3/uTFqMCqdXQFkKJDokp1CRDBKH0YujowNKHDrwQq6nzk61cT5F7FlSpXZY3zaDQWB4dfbVqD8lcBQ5x5XqHB8SAl7lvBuiSMboZKCcgZkWgJjikf3wQA7hSusURLisnaLkBs/Mx+RzL5f+3Hi5NOFSD2WWQrrDZYO/27YPB5Ywy53XdpoO9AA9X3RySlmwiaGFTkES3T4tTFrVaLyWVPkPgOo3p1k21lbVKBNdqhGyb2GgmNfxTKhBO8IL5E4shJImu8FRMLVIWsFYflbRedArxnb1layk3J6M5
 tmOUVBUF
 YDVGxOrUdB4b+vipN+RLU5pacqKA2zcN1/OHF7boVUPZQTdJabgHsYmyMFwgSFV7VOz6LLaQtQgX0D2A6RC4whdOhtNmQsJepXDpEn0tff1rCH1+9AwP29/xaP4w3XS262K1Ta8+o9JKlc58YyLFAyG72XwIZ0vNg3sKUIlAr4avb9oyXXZW4JtiZ/8qcvQBdeandAiyJB9hKrtNRfBnmdiqBeau+wP4gCfU2IhvnCUNeVcFnYWJdbcvkHgX7DYLNl6Yi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 07:18:54 -0700 SJ Park <sj@kernel.org> wrote:

> TL;DR: Introduce a way to get DAMON's best effort accuracy monitoring of
> user-demanding non-access data attributes.

Sashiko is continuously finding a few things including integer overflows from
wrong or weird user setups.  Those are minor issues in my opinion.  But because
the core layer parameters validation patch series is merged into mm-new, fixing
thosse should be straightforward.

I will fix simple ones in the way, as a part of the next series or as a
separate series.


Thanks,
SJ

[...]

