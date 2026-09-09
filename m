Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C67C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 00:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6426B008A; Tue,  8 Sep 2026 20:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A69C6B008C; Tue,  8 Sep 2026 20:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCEE6B0092; Tue,  8 Sep 2026 20:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2DE96B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:14:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 732641C2A62
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:14:26 +0000 (UTC)
X-FDA: 85192302132.05.BAA130B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EED0120006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:14:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=av2lBcXH;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788912864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FNI1Vu5xWgBc1XMbL6PII/w18t/G/EnGzJaA9l5f4go=;
	b=OdN35jKiowzc/xozsGgURRwGOPnStRcy9Ivj03TrDCguhQ1CRD6k1kM+InawuHl3S1p+jy
	uhE4wS+RCNb08nKKlDf6pULv4XdxqM48IGZtKA2UaCh9bccpfJ3J7onzC0FAoqCTNvuI9l
	G6NM6QTwJB8TAVhWdcvnQ0GueszWZaA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=av2lBcXH;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788912864;
	b=ANvApH44q86N86hWGzbqNS4CXQA7IqzFmMkMTzlzaFQEmPcD1Rw6jVOkVRHTUpmLekkV3L
	hmIhU7K7yvEecacLaJlzhr51f2zUCW8yFeftPzGOppjF3sAZPaVIF311iarP7UW0G0YrFF
	SkQ6ldOI2jOt62C/yNm1Mlt0FlOjpUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44C40601DE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC711F00A3A;
	Wed,  9 Sep 2026 00:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788912864;
	bh=FNI1Vu5xWgBc1XMbL6PII/w18t/G/EnGzJaA9l5f4go=;
	h=From:To:Cc:Subject:Date;
	b=av2lBcXHcLSDIN9vJqaTfDCpwq/aj0jcD77rR8IgRLZ8l6N36dfI6WINmE/76CkQ4
	 n0PCsbttXl0PFUT2T3wFKpftgTWzFqNJHfOmDpLwe06wbOjJxFPaVJLP+qIAvwCilz
	 TbXEpBV58ijMf/DhDgKPeqCO4nvzSuPhWAkhxbeWM+3na73XyqkBkc0UasUm5FsmAc
	 oXSKLjOCjNGwg43JAlR9bN7Ozwx8TploFU+9adOOwy4TD6wu429fjVKEZ9+6epekCY
	 Purk6XQbWa7IAXiD0akiZS1t9faNpd7l7l+oUAKFuTzFqLEMUwnQxRacLemKab/+WW
	 8qJJXpcr6b6xw==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Fifth DAMON merge anniversary
Date: Tue,  8 Sep 2026 17:14:11 -0700
Message-ID: <20260909001411.107286-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EED0120006
X-Stat-Signature: ybsf8em8ontt74byi7ac7he379kzmwhi
X-Rspam-User: 
X-HE-Tag: 1788912864-79139
X-HE-Meta: U2FsdGVkX1/Zc60XzZbPgQ5C5hUUSE6/AR0vkd2739RFurNEL17+zDgHSq1TWhT+UI4HjA1VTMbn8tHrOCXKDZ/EfWJv2lTxHEOqJIyWpDDmNH3yR7Looxokzdrb+9nhiWxGOS1KLKCQAovXQDTiE5AQ3LuzIKTccEMjkPh4T+EAiDPVeKQae4FkLyjoSlmNh5Ds9ayAXeBKioHgQyKRryyPFQiMZqYMswh69wDk+bbLoy+jzTBTrSM9ToOvXCxKXPUZWqQ3x1Z76P22Sq4L1vA0CX98nOwAW3wNWGU6FyVxj6TupcCqu8Q8B6K7AZpuLEG40UZQu7oSoLmtrc8p1DeCTYyn1nMCFe5xJ0wWiSiGCyIZqsY5eMsJj6zm8Kf+1L7faQ9QVlvYyhQ69H85R0PfjkN5EQb4azdUD5VdwGcimxWNsuCkiuN/kmE/GgNzrz+YxHtq5w6yK3l67z5JieIRf0sEf8MJsIUqrj38JugaQQuiUCdLLsnHtXoQNBm8eiTBaQgnMMb0Fjjpui6BQPeQxfJuWgmVdSuZ7ZGD1jxk91gdIIn8WZSw1jnrbxsCj1f1SCRSiOeysCLx6hjOfMa8+Dtr95d8GCXpbgpMXPo5efLr6Kq2mR2EvzG89M40CO2pmDpLhabTLTVa6asCp0ibVxf6QB313LrBv1A2z7XgrVSfSG3FggL4PsE5NBQ1/qNrOYmZxcGYd5N0CChbX+KiemqSSqHlK7sKhAihSyzX34N4ZZxV8qYXnAhp6Jba4JN2We8JgtXwIuErQa+G50B4nJI41aRzQaIqpLAEt2vbwZzeDsp6A74RBr63GV/fid7fWOaUNeQDyxO4DJ1qukXN66vKqZ9jctm37opz+8oh1M/8tkQnUMvMtFW7t1MiOmoGc0HJAddQHR674xCaN+YBXt7gAuJmRduKuW3FS7l0gxruRHHL2qb6H5Pt5HEl6HDMZcCn1v7LkFWA4xd
 OBi5Hlr8
 hmc+AONVYUsSO+Vks9WY86itv0s7y7d7306gssMzcj7D3TN0r2flNmvVChT65z43Vy9cnVqrlMxKXHK3apW37wS/OmMDcy74mK7aZqEKxlZir8Q2JRxq8HWNxaTISWQqOBljao5I/1UKo8k76NhRVvO9w7D144syRXH/YTWsTXoVW8PwG4Utumykc0ET9gZ5AnMRkPZu9nHD2zn2nY0oxi7QzHR8cpuDLnReq72yCww7U3MhOFQQWexvAFGIf8UJCnA2dOqETYrg5bwEOeJRUEzwSCGM1BF7exOE6zT91DCTs/sqJESoYYktcmU2P9R54/4QHeWJiMzgRJrIEgT7j3iN7ubztPr+3SigFgTAjBau9ZQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Five years ago today, DAMON was merged [1] into the mainline.  The last five
years were so grateful and incredible time to me.  I earned many lessons and
friends, much more than I expected.  It was all owing to the great DAMON
community.  According to my humble script [2], 143 people contributed 1,427
commits and 49,123 lines of changes to DAMON in the last five years.

    $ ./lazybox/version_control/authors.py ./linux --since v5.14 \
            --linux_subsystems DAMON --skip_merge_commits --total_only
    # 143 authors, 1427 commits in total
    $ ./lazybox/version_control/authors.py ./linux --since v5.14 \
            --linux_subsystems DAMON --sortby lines --skip_merge_commits \
            --total_only
    # 143 authors, 49123 lines in total

Huge thanks to all the contributions.  Hopefully DAMON didn't only take but
also gave some fun and wins to people.  I will also try to give back more to
the community.  I'm looking forward to the next five years.

[1] https://git.kernel.org/torvalds/c/2224d8485492
[2] https://github.com/sjp38/lazybox/blob/master/version_control/authors.py


Thanks,
SJ

