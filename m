Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBEB606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fsXmJYXb
Received: by kanga.kvack.org (Postfix)
	id 9E2476B05B1; Thu, 26 Nov 2026 07:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9923A6B05B2; Thu, 26 Nov 2026 07:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859FC6B05B3; Thu, 26 Nov 2026 07:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5CB6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:30:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BC3F804A4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:30:38 +0000 (UTC)
X-FDA: 85477203756.06.D2EB96E
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2D5C480018
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:30:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fsXmJYXb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795696236;
	b=W6CowOAGlqzyPRk5VPjHjIgBfbmP8gzFijQGLlyAUSV0wRNhOKyDmxEKHx5N9du91KjFYx
	K/j1I0O8h/JoLf3CBBGPQD8G6hc59TRtazJCSN3kQpVOPNs7WfWtU5Qb4n2Po6Id+b0HAl
	+GLuFAyXfFyVVOfOBWo0/rUmj464rh8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795696236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63ma5jEPd/DP2X+W+npb2v4pGvrjKq1tRkWvj8G+bR4=;
	b=yeI/xkUmXsatanozPX/sQvdHotFYknnRHcMvdfGp/RTBjM6gQg8bwkLRTde5RlqrPPTlCL
	TkUHx0Yj0muzrnG+2XXUboc3sUFLI901AtN5ojBn8MJleJ9TCGxREGi91fQvNT48lhblCg
	kflVvyQU2ezX52RXgQ0/8jY2WWsLPcs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fsXmJYXb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-385d8a00598so10236574eec.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795696235; x=1796301035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=63ma5jEPd/DP2X+W+npb2v4pGvrjKq1tRkWvj8G+bR4=;
        b=fsXmJYXbGOwrQf8HLHbBbvdVTbpl6fyBb2hVYfMvbIBVZmqy23anKs1WknJDMd4xS/
         +EoBez3kjneWS24vlpysPHys1YzpAMJJdgZdijZ8hlx98+nvn60QWAzObEjq4nPj6X5I
         gaKCxot8/2UQAm/6GeuWO252/KUmD3QmXX0OB0e7u/wpNerS6FjbyYV3tCURYviI/ZBN
         sETlKnUOB2Ugd/80IEfJ6gZ7Qsi3FARwBi+aQEyNqQNCYuD5bo6TjCRbWjlUby12hZMR
         oCZHXFR+u+I3Ifnf23I1AuwdzxS8CapPJ6uLPt0thLby1EmRu+OFHG7r/hqzJ3t888DU
         ScQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795696235; x=1796301035;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63ma5jEPd/DP2X+W+npb2v4pGvrjKq1tRkWvj8G+bR4=;
        b=1L5+rAOc4v3myLNyfkjhNqCONeGy8QwwBDKHAkZtJn15A8nRzRHl4gCKRVlMKD0RRK
         urmZ3cgP6G+4mIdVSewgPgg6Y/6t1AZm21ENLhU0ttHi603uzIWeDt5AMeyCbfoIDVNL
         MpH1kuk4V9wZHYPpS5npZ9y7dIb67Ty+jIRroE8XoxRHXpQjTWAJuymLG7FlND9Vjuyu
         rpjZtKawv7bgIcpkleO4x/tW6X239evun+Foq47NKGOYoqMCxZvT0g07ofXjZfYMedjX
         R/HRBJom+AhArHYpmq2C3ZJQtjelg//CaYcvjWqRsL7NsOOEgq0VmWhpBYVaMupnDqnj
         wSIw==
X-Gm-Message-State: APuU4Z9ZOtlrxRAJkecBlQN4gWKiBK+QDX0XiPbf91fQZd7B+QHhinV2
	B6uEUiH/FhdNxidMjAeFECNI4FneJNamXHdRIlivUEXTU1cRW8SKiIpY
X-Gm-Gg: AZFdTZd0O0poWJkAtr/SACfgFQGyU7AiPBaIrbqP5M7/HNh3/oBoIgXe72czLH4Ul/g
	p5/BjKfDzej9dSINs/FmqGCER7qxMfQsGGcemsMEBAIMEDHJTBw0Js+R6ojaUlm9AyrH1u0bEKE
	KKkIZyOxuIdhLqqz57F3i8NjEMO3WMSESZqconeS5T7gBEQPs4lpQ06ukHXpWDFdQkGkNV8G8nr
	n4/PSmXOtLuhI4JoP/k2DV7XHuALW984ebQSojrvbse9j5UQ/TixinWH9YQQ0COcKifIByIs9vM
	kTkaCa/j1fzB0foHVuMY5Lio2+t5uXfjE4JhRW7KMRs44BE9by+X/ZND53RmMrG/Sn+S4h7Iycu
	dT5wje5othHRtrNOUuU7oU3BGoqa9TYR0cUxWMu/OzMqFjLH08aKSHJO9TluQ2HMU7tLgvsFdTA
	RPynFo4Mk6rILFf2RIQw58KPwjxFIVK/N6v96sKGiy7v6tvIgA33wbPgcap69sJalMWWSFLRqfB
	y8okiBOcF+MzD9g+6QivPUzb1w+ewlXAqb/T0XCBvb7UYrinDStMzvne+sgCWRa5vlD4tpKzcyd
	J4emQj2rP9t1IcqYgF4o8wosH102I2VpV4hfYZYQbONpMHGbLocTo9j7/6Owje1VQC15zjgX7t+
	8a56DxA==
X-Received: by 2002:a05:7301:6191:20b0:375:e4de:96d3 with SMTP id 5a478bee46e88-3869e61da0fmr17122398eec.31.1795696234586;
        Thu, 26 Nov 2026 04:30:34 -0800 (PST)
Received: from HFGF46V04Q.bytedance.net ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672c6f31sm61373340eec.15.2026.11.26.04.30.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:30:34 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 03/19] mm/swap: cleanup and document swap device availability flag usage
Date: Thu, 26 Nov 2026 20:30:07 +0800
Message-ID: <179569618256.54252.3159687265879392207@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CACePvbWLkZtdX-kedNHeFDRV+e3Hcyzixsc=9eENTrZVhiSjjQ@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <5a83cfe8b0992c65cf4cca1e8cd612b4de0b78c6.1795439990.git.lianux.mm@gmail.com> <CACePvbWLkZtdX-kedNHeFDRV+e3Hcyzixsc=9eENTrZVhiSjjQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D5C480018
X-Stat-Signature: 7mpg8migzzez9emdngi9ndwmjwe56k85
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795696236-158436
X-HE-Meta: U2FsdGVkX1/FvWs5vn8TeXA/6yk5lcLj/0nhgzMJdWd2D4mrrcfPQP1apwxfA2g+zazo542i7FoJexZS08T8IMUWoEtyPNQahq/1fSyWtOR85m948utd2Xl3lEAqYBrk+14ukRYCunWzpEnkyjpmtDf/gEvFOGQ9G+/KRHV1QZnJIvoZt/86bwocgY0rlkuO1DbqIE7Wl5QjLd7P5RWTd4SWIGe5Q35c1iU+/nO21SBlaVCZ5P289dW5mkqx3iGKN6JLEutcIXOPQTYta/aEchv8Ee3+nJ8EUin/iqz+nCrryiyMUOAE20mouh1FXacQEqsIixltW65Ql+PHu0cINz7Xo57bd6WsDhLfrYlGrP/3Jzligbo6j2eqDqDx1T6v2AvUu3FibeISwOeL97Nr+hS7yUqLLTHG5UKPVsZtuI6GtPXpZP4dWWzowvFo1+H+JT1G1/XywH0z7FpUcArAte+ABgjt456H0oRc7QXHXM9wF0kUbsL4HjKqTkPpyqQ8SOGyA7KvUeKzJ6AXihl6TELDDRIUex5qYLj+DxZ5I3RogmVQtL43G06ToJk6iO4ywiPap/CnUMJzeOqpYIoGz7X/FPNCe7osJnOvXj9rCRyOSaw5539POkR1256Vd11hw+mHfamkP2ovTVpubDMQ7Jki35C30iebhc24QrOfsTblcAYMwM3POVjRqBbt7GwSK2byauri/2YHt+8y4tzVVLuAgEiJA9Q/+BzRW0OdJnf18TETceK7SAXfRNnjnmhGQzKFAiI2ZsqMllGUHEWLYCz1v17YzFUjaXFV5WgjTBIo33ncFMTj5NUnNMxOX+ieusS8vrK9L4nMsDTO8GRwPnzy8vUY6ii2kTSQEv385BH6HfxTQFg0oixXvqHGkLout7SusSm3/w4eXE0Kni0yW+tY62zskw+bgBENpZsJfxT5ubLQzZ0kATsPHBTdHp9VYeTP9KJOILMmqmbmtAC
 vI3aPUWk
 Zdt22czFSO5EZ7wSbYztPTWoxdCrFolDyuKiYpMFLqqhOvgY/Qxjpskl+WTCiibpD/fh5jZ55VkjUWkhRPkC814DRCdvv+zE7VmJbRm9R+Rd4S5Y7mS0RuN9lj8HKtkQ0u3pGV7O6J6KlD0ExeUt8olbG8um2fGcJhwFbQFYQRnCZS7M6soTtBMkrdKucIMpDk0OM3oy8wlh0AJHPsFSZuJN5R0bjbpjpqWGeP8qRT0wmn3419BI8C5n7tAWexkDrv77yzqmksGdx+pycgS26TxRmxN7mqF/wLv1C2/nq5gEqI0mIjTkyMPBEzhsnSDOxuj7mp9j/fUNSWmclstU7P1KXyrkEMBxPxmGTieW0uBXn5DJZxDuWlDiHwzDqSdtT5WH0Dm+jhozc5r/DNmBP9Le5BdMXCDtg1Nq5BgCGLF6YGmEaOhsNCqLOHzxtgu9EJEvr5CdSIbvMIY17yTlWaedStq4KxLSFwC78TK+5ZhLcxeia2j3uWykE541PBfoXxt7joytccjbuuRXziCZhsIfyV88tbia+dT7tz8lTT7Ig43/Ka52UeKyJGqAuem9xhyPO30K33zQPaTzE3gt5Tk5/P8Pf4AUblb/9blCvC8hVUGVqpsCvWwR44TE5WTxvpTTWn+kMHRbtZVxSiKM0JEe3sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

Thanks for the careful review. I kept the enable/disable helpers and
the call to add_to_avail_list() outside swap_lock from Kairui's
original patch, and later revised the locking around device lookup
and SWP_WRITEOK updates.

> Why is this change safe?

Both before and after this patch, setting or clearing SWP_WRITEOK
takes all three locks in order: swap_lock, si->lock, then
swap_avail_lock. A reader holding any one of them is serialized with
those updates. I'll make that distinction clear in the comment.

On the swapoff side, what changes is that we release si->lock earlier.
We still hold swap_lock while removing the device from the active list
and updating the global counters. The old code already dropped
swap_lock before wait_for_allocation() walked the cluster locks.

> what lock protects the avail_list, is that swap_avail_lock?

Yes. Previously, we set SWP_WRITEOK and added the device to the
available list under the same swap_avail_lock critical section. With
this patch, add_to_avail_list() takes that lock again and rechecks
SWP_WRITEOK and the off-list bit. If swapoff has already cleared
SWP_WRITEOK, the add is skipped. If the add happens first, swapoff
removes the entry.

> May I suggest splitting this patch into two?

Agreed. I'll keep the first patch to extracting the helpers with the
existing locking and operation order. In the second patch, I'll spell
out which operations move outside each lock and why that's safe.
I'll also keep the original if (swapoff) branch order.

Thanks,
Lian

