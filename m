Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D190606D475
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BQ9D14ku
Received: by kanga.kvack.org (Postfix)
	id 447A86B05B4; Sun,  8 Nov 2026 20:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F4D6B05B5; Sun,  8 Nov 2026 20:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DEC6B05B7; Sun,  8 Nov 2026 20:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0E966B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 445861204B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:12 +0000 (UTC)
X-FDA: 85413832224.12.3CC88C7
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EE79140003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BQ9D14ku;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIKqZmT0ty0azcehpTXQx6Fod24WVOZtqlXVR1uvvAw=;
	b=iGNMozsLeh/CDsz0dKXGnRWOM+wA1JW9IwrmVzUnd0ztwWPRg6+kMj08Go+ImILk+b5J//
	ov6JrhNkCloSn6uYznaZ354A+yX5aBaTvRrPGSr4ndE+1wEqAQ8IzixdSPSYV5npH+8g0r
	lnoiw3CYJq3RBk7R6mPKNtNO7weFPhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BQ9D14ku;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187390;
	b=JiTbOxVuPtpv9bia9ymudJUiqs/oR/oa36FhQ5bZTlctu7gsr0JlQ+r9catB6GRFTCJmuk
	QjsSK9iFeKhtOy7XHJvb+si2nyNaUZk3bSgdWqyd8L7v4iA4yaCBKVg+hQppEFAL+hamqo
	kOfdv4ue+Gid9JTCrqAlTvW8gsMiv58=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1931ff67a29so1029470c88.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187389; x=1794792189; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yIKqZmT0ty0azcehpTXQx6Fod24WVOZtqlXVR1uvvAw=;
        b=BQ9D14kuD7Gdcmy1eXxERZBLOT6az7q/Tdjyzryc959xYaisj6jqw45vfVz1uNu/c6
         41UiivbmlR3+FDGwirxG4G2JIBZlUs083QnVmWtzXSh2C+RhXtapIGCxhKxo2bI5RIx+
         P2r+J5f3kknsTIUfbGetxiJvmDIZ/DJZQzsKfHLcq1zw77ah/K8PJzmmLaKAil37Kwjz
         Cp11Bfb5q7Zh30AdmoSadZkOgAdeNY3C2tJ/vRKD3QGai/qyI1M6qAIdlrIXNUlHyjC4
         PVO6hOe/UcssKWphmtPO/ho5j/LtFG999kdel7DIj4jC00GJOSGokz00wHnccRos4oMk
         rPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187389; x=1794792189;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yIKqZmT0ty0azcehpTXQx6Fod24WVOZtqlXVR1uvvAw=;
        b=tUPWV95tvcBeiPSsxi7exyc0OTLDoao9mBSmRYqA50xW30GZkZr0Vgr9ZJHWcg75fw
         Xt64huYT+afA54MexBeoVg3l9zijp2p36r9pt6kAk+htWM9l65rQPBj4umVdfIzE1q+v
         8CBwJ1l5HCh9b9E5pyIrdCyG6cjRlgv/jwBlYY08qCBjuiGTXVDsvzzJ9FjPeGUKDhrR
         P9osQ/6dcQFFheQ5IMI22cKDxmn+iBmNHz9KXsJFfkI8rPfHK0Mkyu06jPpXkicmwExR
         huq7CBt32b+h7sLkKl/EMIBXaWduxD/iwUQpinAgu39chscTUswmHXeD+Imv6Zwr+iy2
         qA4A==
X-Gm-Message-State: APuU4Z8EXzPjntTqzp+MrA7So2MVjU3aWXubOxRWxQ68RN73bioctVU6
	IeCxzUQ0esGO3Md3/dVNQ+3lVAopDc7M3SBNFB/48HfrdIFieFI0qI5C
X-Gm-Gg: AYBFou2woSf0lnzbgAKcnE3S1Ezqh3FSGUHEYAjpqM0MUK/kDQcknn1VRW1PKZDFOiI
	3XD4ZMwhI9YAbkV0rAOJsBvkg/GtZvXloR4YP0ASuvC8IXItEuIzcoOEue0/Zbss5WRTiwLkRlA
	5GDZgvJRXubX4GoTK/zNEbM3IT+7YCoajdrVcY/FrquXTxYztcYvu2Y4K+fmiylXjodaQSaPRK5
	XOjcSwnU3h+lp+G//eK8jS0T1T7jxYuEvvwQ8oySwXRYIW0eQy48V3avO+ebCZspv+hmIJJq7II
	pfa9H7YqSI/V3g+67m/XCQlC/3smrs6yjLHR3XQHWR04FJATDrk5nx4UNQ27a36veWCIWxXUgYN
	wYkfB6i2d5YwxpsvRfy9ppID+jNS4/8Omi07HGn/kW+iNtVsl8sBcXcRGxgE8eZakaOTQomG1tt
	zMFv7ipQ5KSWRqKGc2kKK9sU51BllLf8nqj1CQzy/OsmLnFNyLwUjuqzqYx3ZROjctjVUL9pxKk
	UzHuEdoe78dWjxGGF5JY/sQWb0vN4h4nVlIylVd9+3EwIH9aRfKytTB0ItJrt9tAWZHNc4QsmuM
	cJIYUQSSuT0hgPeKXyy8n/Kj
X-Received: by 2002:a05:7022:2209:b0:1b3:2692:2274 with SMTP id a92af1059eb24-1b39ff060a8mr6502765c88.40.1794187389081;
        Sun, 08 Nov 2026 17:23:09 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:23:08 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 08 Nov 2026 20:22:51 -0500
Subject: [PATCH v4 2/5] docs/mm: ksm: describe how smart scan picks the
 scans to skip
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-2-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EE79140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4h8aycio8sri3hownyij5ydobbx4sd8z
X-HE-Tag: 1794187390-272093
X-HE-Meta: U2FsdGVkX1/NAK+K+RXJQ6IxPQOhcMtbUISWte2KCWUhNekz9H6tuYDAfcV67BjnlizOIQXfLTrV5KDWl5ViwVo9CEUSnJBqFPilDPgkVYBa5ZembQCmUac2rx2D2KgsgdWFZbq2c8zkeVpFWtyCCzu8dPxbfOJTCn3DiIakZvqPN48VO4c2AK7G6sf7YjcAuKMHxyXoGKzo/TjHLYSl63N9+ubB42W4roTsOXAPmn/WEUxpCQ7nBO0TZ7fhT/68XfsjqB8lvexvNl5SaqtT/Wgas4r0XKRysIcYsBml7ULCY8LYWzF3yFwUnZ6/72OLs/gQGbjwJ2XWTZb/pO4Zc6FCmdFkNtvMKNZzrvfmJaXDzAD23A4ioL+sfC++HSZDOGc1Lfo8El/yyJJtO8aZ/Aq3a3Z6h10Jwi8sw4TkwioFSmwJAbKM9LAEcpsr+ywYIW/0Cyzw1FtWMe485RL3PEU1P/zSIa1S3Kw7P/rXWlufovHh/KOzYLA1hb18mA5gbB4ykWX9omF4lvelE7rch+i4HD4Vvy7Ga2037FxQ7ANAkT+PcNtl0knJWMTakDwmy8zu1rATaR2C9YO3KdieIsGr0xoxxz+xZuzHv9VoPuGVqU9njHI4Ka815CICh2SyfdcL4YAScIfH/aD+2Y3vDU/LNBwF1G6gylKR7RFK8YI4Ze8glpjCK9GqbCgaUwQt5x3fojr3ILmj9/Y1GG9hrRZlFuE5/3pheT1mEYno4j24V5oTD6sMOhvvzU4lypadhVwitEdKibjfdayGuPOw+k75lG8+yr2BCQIPzCafjKrmFy87iH+6QVshcJU4/e5ChyqMFMUBtx/RCMgTXKb5wHpdKEA1dccsTGjElMSdzXk7SerKNbXi7TiAbx3sUpCnSWw4mR/xP497R6TkGHrcmOrYzAOTTX/o1yH5FSGXf0JSaZwTFNGJrfZ9JHOVU6a+q55Ujug2QlflH0Kj/cc
 kuLqPsGd
 jbtxv1rZrCmV68gFJoh8cl853Fx1kRXqzWtohhhrIK9vfAfuYxDd+9fFxW8Eoc6vkSXPNSWpsqvn4/l2bfFJQz+kpcMcQhDClOsf9BSu3pAvRdQggWUKd8vwaDuUugpTaoNXjaOUmYNbEBswH9vz51viYFq1wqUDxlU/WSQ/fsdVLPZh8aYc732bBvrq4U02Ecjj1mNWW4wo2IarYNtcYgk1eBs/YvOhCTw8onykLtc9V5/37IPukxQktYFhAO0igw6Ou04MRMJdWKz+IH9jsCsMmrz+QgNb10FL6e7r/Eq30dftgOXDIkKmq70tpx9wCv92sfS5s/cc1lf26wdwXPtPal8YQ0+JPwuy5Xv/6hg62kpm+4+RsFwIMBKvRH15AmIS58XtQFBnxYcoHQXmgGyXMqVZ0c/Dn3rRKGox5gk1NhHQr34zUOl6jXyitJqbY1YQjT/Ua408Hhmy0UZo42yAiHmrRBidg1VrNM/ZUD+U21ukaqN1FMUheWIoAjx0yZ5u6Vbi2FFyGpD042V0ZwHpFJv7kr/bxnuA/MOTUXOAG9N2N2UCC+Nhmg2BJrcRuZ3w0LB2xXvnuDJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Documentation/mm/ksm.rst covers the stable tree and its reverse mapping,
and Documentation/admin-guide/mm/ksm.rst only says that smart scan skips
pages KSM has failed to merge before.

Neither says how often an unmerged page is looked at, or that the scans
are picked by the global scan number so that identical pages of
different ages still meet in some scan, which merging through the
unstable tree depends on.

Add a section on smart scan that describes both.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/ksm.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
index 5a80573162def..f954d221e8017 100644
--- a/Documentation/mm/ksm.rst
+++ b/Documentation/mm/ksm.rst
@@ -75,6 +75,22 @@ The whole list of stable_node "dups" linked in the stable_node
 The frequency of such scans is defined by
 ``stable_node_chains_prune_millisecs`` sysfs tunable.
 
+Smart scan
+----------
+With ``smart_scan`` enabled, ksmd skips pages that it has already tried
+to merge without success. The ``age`` of a page's ksm_rmap_item counts
+the scans that went by while the page stayed unmerged. A page younger
+than three scans is looked at on every scan; after that it is looked at
+every second scan up to an age of five, every fourth scan up to an age
+of eight, and every eighth scan from then on.
+
+The scans that look at a page are picked by the global scan number
+``ksm_scan.seqnr``, not counted per page. The unstable tree is rebuilt
+on every scan, so two identical pages can only be merged in a scan that
+looks at both. As the periods are powers of two, every page is looked
+at on each scan whose number is a multiple of eight, so two identical
+pages meet at least every eighth scan whatever their ages.
+
 Reference
 ---------
 .. kernel-doc:: mm/ksm.c

-- 
2.43.0


