Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827F7606A31D
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BsQfTe8u
Received: by kanga.kvack.org (Postfix)
	id 75CA16B05B0; Sat,  7 Nov 2026 21:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D716B05B1; Sat,  7 Nov 2026 21:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC4D6B05B2; Sat,  7 Nov 2026 21:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 339EB6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:40:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF28340382
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:40:30 +0000 (UTC)
X-FDA: 85410398220.06.AF159EF
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7306100008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:40:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BsQfTe8u;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKWYlAcY6So6bitWGtla4+mL7IVkoD8l6fm1ubuoUDc=;
	b=gY5kQ6ufm38DZ/NoYaaH3616G9x/vJ1dzLsWyZ7yURJAE9K9G4NZR0KnOVdALDMknDLdfr
	2Cjxjl57h9nOAJK2quR5ESYM0hSgnmNiGjMEdLF89TBwp3k9jhMY+Ou5BF4Svi5HGapGwp
	FjkdWJjNsDF0/n6CmpCPGuXwvia8XyM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BsQfTe8u;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105629;
	b=pbVb4eA7czQqpNnzsFJ07Tz/a4pJr1zj2XeJzwgRF/IKGZMYnWrCvuJouew2RnvcPAhVLQ
	3W4prg223rO9NjdiXiP+EScSdrigpaM7qX/oKFBbbOeK/cs3mzCzIy/7BQPIUEB6abpRjY
	x2pzPCOMHeHfVYACraNE9LMkhfu7uQI=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-14394530ec6so130686c88.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 18:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794105627; x=1794710427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oKWYlAcY6So6bitWGtla4+mL7IVkoD8l6fm1ubuoUDc=;
        b=BsQfTe8u+7keI5MFpauMly2ijTEfNVKv1Za5DuGUgG9zsg7t9S3eO7znFVn5prqQJ7
         dWa/YThvX5oGJ+BHg2p8Wd/EJNfjIsbfuAO4sbYxSt5vU7GkTwl43N6BTT02v55PA6SW
         bpvGE+96rbOAvqcM0I80lLWbgSFWgnzS1rp1CW4kuOdK5iLikuus1itIk7qEk/I7SUwE
         eSLQBmXws7waE/E2VMtdqrobW89eoHOPuIU3EyftOvua8t8khFOBEO+mjuy6ACNNUak9
         wX496n5BA1lmRaWwq5M+O7pqTuPsGbIsk2LVvWHk5Y8XbuH5Se3AMGQxZrZHYOD9UBkO
         5C0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794105627; x=1794710427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oKWYlAcY6So6bitWGtla4+mL7IVkoD8l6fm1ubuoUDc=;
        b=DbiJ0/Cs0dTnlZmh3dXsvcvqaCLjaweNvX25Fg88o/ih7bK2qRsljE6sCq/OXmQlBj
         yvI+g/0UAbfTkQ5lutEwaA7gSD/E00Tc8nWVwFAZV8uOYKxfgCT106e/zK1wEyy9KUZS
         xEzw4tqOuPsek9weV0v61Xqa58Nd+MpFNRnjGzqJpzwON4cTsNuXRnALMhlcKcKM4Zpi
         aV9onqbEAm9ewD5TJDKZVW2c6s9ZOT2YAMJjnG8YWWocQ4hz+jhi6khaDtb2kgNs0599
         CPRoVO5NscS3n0j+UzgNnI7bC9B4AFZ3OesAOEt9oVtsWksxc7VkIRRejqwbEQtEw3V2
         z01A==
X-Forwarded-Encrypted: i=1; AKwUvBzk/zslLCvnLnDgIL7exIgfkEoq1W2S3q/Bd8AOzY0YhHq2NzhEusVFLcNPZ9ehwwvXg+D4dn/W3w==@kvack.org
X-Gm-Message-State: APuU4Z855HSKIJUBUaJWEBkoOKCx8WalzymifEL+CRNJSg0nwIrimbtD
	EKwos+OfVhdN7iG5fuDHT4NzdC/WXoJgyehDDB5qhULoUgzAYslSsO2G
X-Gm-Gg: AYBFou1/NJOTZpe+wP40gebyTczJxrByeY08y/D0iZHEGuDq+hVinuzCX+vJEgpfvtv
	wuyoZIlJPQPhGv740PC8zvpl+p70moVGZNViGqKGyVP0+ZjQD5BtxVZuU7yF+Cu7tK9kMnMbX62
	hGtQtoxgHBhud0NIlOabVhy5KfiQH1PylSS5KcNTk6Y1DO1/RuhYLbL8TYSXV3wUIEEok6f2f5+
	VHv302AuQ0UvDtd3ux7g/SC9+bJo3MhOiSvIGGg1Abs4v6KmsMK4xB9MRUvGWe9jQCfVTLYpj1Q
	DqIFvNyQh/eQrQCPjJQhaXIdyHMbZJ6BfC2mjkoj/DEPrY8kO//a+vtowE2IfODkIAnSHBUw4BR
	IlBjeXf2vJOF16ehWoi/I2nKGlkawwYS0Ug9VEobSDPtQqT4bta0dCxa18ZJVOCeP6ggAMBYyLH
	npH8q9q4dJ2zkFS9DPpCt7995WIlnoGKqzFaR9LPWtjzaRhcNi0qnRTfspBxlLvC2mZ06bjrn79
	U8cBLI/ORLCVdSIVogrrmGAUEJ6N/V1cdoChVYMDqCAzFtC/q5v0HNS985JLEmj5NFl9MukkQkC
	1x8HPBUoqF15nhKNxPoG
X-Received: by 2002:a05:7022:29b:b0:182:6c6c:d876 with SMTP id a92af1059eb24-1b39fec1c25mr452900c88.8.1794105627500;
        Sat, 07 Nov 2026 18:40:27 -0800 (PST)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771e5728sm2228842c88.16.2026.11.07.18.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:40:26 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm/ksm: align smart scan skips with the scan number
Date: Sat,  7 Nov 2026 21:40:19 -0500
Message-ID: <20261108024019.1195186-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7df793d7-55dd-40db-8455-1f22bb44193c@kernel.org>
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com> <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com> <7df793d7-55dd-40db-8455-1f22bb44193c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8tmfhr47dmtph6qwx5ydj6fe3ye9gmpt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D7306100008
X-HE-Tag: 1794105628-897994
X-HE-Meta: U2FsdGVkX196L4aEpyOlxk+phuKVQ5Vb2sTifJ3EtuwO+maZMFgZORJKSxpP/vQ27/wlm97EYW+LrlOJVBMPe4/wYGdfbr0EZSCRiuNhOiPdyUUz16qdyBEzwQ46EoVqk7AG8GXBlgc2L+1btVsgxg6wGFpBgVZMK0ig5A7pvJ0ZVixRBdPZR+wp5QoN+1/o+LW2+Qph+TZF5uyWfzKYQqzeBYWJ3+LOK/mqBmpvcNLc6bcRGqHAf+RPu+5YgSDUw6C2IzC1ingR/L/s/0f/9zQsY+WP2b0M03/I4Wd9CmJ9bNuIEnKhLSyDEv3xkXTen26we1YGJt6jrUq7dDBXBxkwqBefmp0Bd4aHu367ntbzGoL/pyePqnHf/cE3aXQpoZdQcqQTqjer+fbuA1xtxkELTAtKyv45Gni7V+lwEnNckd5eT3aNQ4921Wwd0JopU9YyEyyrld1gaoVzCjSqBpWHQfPVIEFl5bx2daCIq7aGAqf5rnE/rKjfEZ6p0Bz6dOgE19IdWUmaLg2e5s5GH+yhURol2fWBVEgvNgfGjDzJdSVxuWgvir2bpfC/pbwkYslTpXPng43qKjE17rlwseC2EHK4GkvyMQeDyIZymBRVAGEvCsJeyEklAskbtaxCtaXUBOyz5CfqYdYsMdvoLl36kvXZDUiGsJv7P0HEY1XVh8NYMhf7jnPIR90jzad0FjMqIbYG7PosYw1F/+JytMxo4gZz4AMIWIlEu7dIklxSEUF0dysoTyI4miyr7+o5QLaeWmPgNRBCksHibyBibxMgYZrfkYAOd87ERxlxi5Vn1/7zf+dux3MFUJfAd9oK86q7fkNmVcvzxgpr2frCF/MLAkYF+lh8pmKOaWtQE7dGiMnba6fkL0a8NiGocQSFqKRO1xEynoJHxCydq6Cm9PzfZ8iieWCNTiz5IGk2v3UuJEcpSb3GOA5cDPyRTngCRS+RqKcdJgOGSOe8ERm
 XKzAQgkP
 Lb62hkhHOeVUom6tZCtM5SFJSIkS0/G1FQ5gWdmM4vU6SCE6aYRqnSsSxLiKCdDaz/6hJLfiqFjdiJY3XwmgnM1NaM5Cq62K2Nh1LTkoJE+KhK3aQhirkYB45lLcl8/YUpZep/HcysyX40D7Q9VzLP9jcJFPc2HqW9ZbxjZTPZLyNKQOObOo0gOs1BN9vQeV3/+Kadfk2Hm3n967aLqsLdgyCyK/62gbZDLeJlW/OZS31jJ2s55olDPyMXhJR+NOkcWLsWF6/ShCf1fmU3xqI7T7o6njc7ZM8oJgEbbJTnMirdvaNdRngX+MTY2bQFuIYaGewEQtMINggsIBsXIDyzaZf9YN8vUYXA0bkihKkLU0hTPTyAlwtdYLDqKrQwNuWFA1FUi8p93EW/QZP1iOqoCGPExaoN965rNJjCC+6uZB+rTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 20:51, David Hildenbrand (Arm) wrote:
> On 11/7/26 17:57, Qiliang Yuan wrote:
>>                               before     after      after/before
>>   pairs merged (of 420)       361        420        116%
>>                               334        420        126%
>>   pages looked at per scan    1792       2048       114%
>>
> 
> Oh, I was wondering whether this should actually go to stable? Do you think the
> above is rather an extreme case, and most users won't really run into it that
> severely?

I don't think it is an extreme case, and the test above rather
understates it: it makes the second page of a pair mergeable while the
first one is still young. The age of an rmap_item only grows, and is not
reset when the page content changes, so on a long running system most
unmerged pages are past age 8 and each is looked at every ninth scan, on
a phase of its own.

To check that case, I let 1800 pairs of unique pages age for 32 scans,
with the second page of each pair made mergeable 1 to 9 scans after the
first, and then gave both pages of each pair the same new content:

  kernel           pairs merged after 16 / 32 / 256 scans
  before the fix    112 /  200 /  200
  with the fix     1666 / 1800 / 1800

Before the fix only the pairs whose phases match, one in nine, get
merged, and the others stay unmerged. Three more runs of 64 scans and
one with 128 scans of aging gave 200 and 1800 each time.

It is limited to content that is not in the stable tree yet, since KSM
pages are never skipped and later copies merge with them, and the cost
is memory that stays unmerged. With smart scan on by default since v6.7
and the fix being small, I'd lean towards stable.

I'll send a v4 in the next day or two, which also makes the new selftest
helpers treat a short read or write of smart_scan as an error, and can
add Cc: stable to patch 1 there if you agree.

-- 
Thanks,
Qiliang

