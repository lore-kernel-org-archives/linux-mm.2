Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310F8606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aywVmztn
Received: by kanga.kvack.org (Postfix)
	id 47D666B05DE; Thu, 19 Nov 2026 03:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454F36B05DF; Thu, 19 Nov 2026 03:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E6B6B05E0; Thu, 19 Nov 2026 03:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18D2F6B05DE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:53:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB101A0A01
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:53:58 +0000 (UTC)
X-FDA: 85451256156.03.B98052F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E5E01C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:53:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aywVmztn;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795078437;
	b=EOeKxD9EETNuPjp4J6u/8TfZzhvmcxTqyqAJkI1EiiMs6Euzrv76eoGKoIsbfDcwM+BWM8
	+n4Lw2bRHzo1gcnsz7Yazqa7fikESRNJXS3QHmoBRnyV7jhzOnlf7dhVe74F/3swK6Stn+
	Kpmf0W60qMT+ESRIwS8OhGFe9PTX6+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795078437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWV5J4xvs6iOHJRl3GmyFLPLpFYLz1h0yKGuTf7y6A4=;
	b=JJM0nCe81xJ9tTqYzX4dRcFdtvheTX4ybNfZOjprdSTgr6UCKFD80gOF47IUndmWq0Swtr
	30b+iP+4koelTCazqzN7lY42R+hn9zcq9uafWZbarBoxwkm7vmmyBauRtcj3dsYnIIEefz
	EuWfdlIFB1smtQ+zhx3UcfPsPnZFncE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aywVmztn;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A776E6117E;
	Thu, 19 Nov 2026 08:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363351F000C6;
	Thu, 19 Nov 2026 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078436;
	bh=cWV5J4xvs6iOHJRl3GmyFLPLpFYLz1h0yKGuTf7y6A4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aywVmztn6lCDhWsbgc4gtgi8iWWjN5vcmsHnF5y3sQ8I42pjbvqdMXtmN30PfZ0FD
	 CEzPxLz3uJw/JlppC6KA93q8Ojx4GyyViZSlndgLmSmyykXfprp7qXbEbp7OSOHLeo
	 wBFnuvVsiImNqVhE75Dwt44E/o5SKzu7fxJkRWvNaUtAokJPEak9GDB6j2AJNIFuxM
	 zVPGwIp0GZEDvgil+8ynHv1OBfJpSeqBrnjZ8PpUilF3bsiyRGXOJ1UyfHsEC1W8ve
	 0BjT2hUlyFCZszaUMgwmvW1kj203jynHnVeaii/f+FINcfWuK7Z2p59RVlIw37VpOg
	 K5qqDo8ymBFWA==
Date: Wed, 18 Nov 2026 22:53:55 -1000
Message-ID: <74ad05b502dc12632e7a831be7641388@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yu Miao <yumiao@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, jiayuan.chen@shopee.com, nphamcs@gmail.com
Subject: Re: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
In-Reply-To: <20261118130537.750211-1-yumiao@kylinos.cn>
References: <20261117062620.346767-1-yumiao@kylinos.cn> <20261118130537.750211-1-yumiao@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1knwsofjb57ei3wyc3rk3t39sr4jompx
X-Rspamd-Queue-Id: 1E5E01C0005
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795078436-156286
X-HE-Meta: U2FsdGVkX1/g7E76QSfGv+s6QcIBKc2g+VrrcpMGqN6v3HMVakjsqNFWPsvZB11nkvt+dn5HNpHa+w3VZCfCWWdoEP8HXWHViGL48bBoocqyBekRLC0l2r1ikr1L5fUmWeK/imNKYZpnbQamhIqYqB5HU6iOuxpTtqE0YpSLgj2G/8+UdCE5a/TIxMBsdtqtI3VX0/60PoTiDQmU2P6EKzOJgkMnMzbEj+Uj+FAdvfPAnWdGrWRMqgKbp6o9WzQk1k3HLt/y9S0gtGnD1RRp7MWDFJPGz8JwpErAJuC0LSUQz9+0GRwlVLwgBkLUq5PQVOILUgj1+U8GAMdd5vrbwDteIkiRLSHE5UqQII5k6ZHZFEvTN5SD6jb//XnnszSl/QylfwN6iN5AJViYLpKmfrv+U44mTfX9JiU/vJ6PPSj4+EF40O+LKo9AoqGMdi0kaTKOZpYRR8TqTeLOKW1eoJ6oHw0jtBXcdjZIOUY6vhbuCYFppIFVniuKRS96Um8p7hSNwd/XSilfecZA68XfpoO2AZHFW5+XBhIERU8LcrfGr0rw+nUFDnonIeMLBKsgX0ruJvDy64BYMpLKPey0qdpzRtPwb4bBFghLYceis8Sg95FRSON7DiKcRsrr8N10LmqCl6zUp53YCBYctqCdVv4+vy4dZCMSDzcSoW86U1MA83yNae481wEQnHX8zpFlMTKot9IZXhuJSOXJtEGh6FLm4ZZL8sJOnAliYXLSYakbCFNfhgbG1PPhpcWPPd2JOu3A16riYHhrcrPprKiVgQKdOsAI5hQ0R/SpCqBxtico1QGfX7qrtL0ETh9vmjHWZcgFQ2fye5MTz4TY62T0/nffwCMMHNu7sg0k+RbkSwRd3yFYRQQSBb3osgbJ8qtQ8zbtS9yJjFPc0rO0JHfWbl59XxNMyMNLoycxBLu1thvUCaYgV4YLCxGj40nLMNoo9mzahpWfloByU5F73Kh
 3bU82xVb
 k1Ytid56G0GlCc2r4RvSCx/btiVUuBOYBiFN9lLKzbc3OOFB3IbjoPRgBMeQccgj8aaHMxvexwwUG7ugzF5PLqZkMA8/o+l6Lk8gY/0SoY8O+o6/MuKWVizjVol/e6M24ns2xApDf6++VG+BK+qiMTUIuR4dtk47g4bvxVHezPD9o9AslsqoEN2T18TzaRAS/jVrfHv5GOGjNzcXM743+nJHgvt0aDmztXNUYSSzWhyOVD/X8KODPaIMwPuCN0O7CfUsFOVbazXRjjbTxh5iY187Vpfw7yE9NZ3xYB4H+LwLFPz3GZ0BHgoN+Z0fKaMbCCpcdMQeJGiZ2ID2lumhOrxzADRpS4/L1ZqaiCcSLruMKjUy4kYFRH4hq3lX5wwB2v0tRKflV60qU2jMDT60js0mX18CcrUMEP3G1YxQ02nGYDLWtJdj+Zafr5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:05:37PM +0800, Yu Miao wrote:
> The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
> zswpout and zswpwb entries never show up in memory.numa_stat, so add
> the 'npn' tag to them.  The pgscan_kswapd, pgscan_direct,
> pgscan_khugepaged, pgscan_proactive, pgsteal_kswapd, pgsteal_direct,
> pgsteal_khugepaged, pgsteal_proactive and pgrefill entries do show up
> in memory.numa_stat since commit e4f4fc7aa8b7 ("mm: move pgscan,
> pgsteal, pgrefill to node stats"), so remove their 'npn' tag.
> Also move zswap_incomp, currently listed between the zswpwb and
> thp_fault_alloc counters, next to the zswap and zswapped entries
> it belongs with.
>
> Signed-off-by: Yu Miao <yumiao@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun

