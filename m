Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF00606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=W58eZLA2
Received: by kanga.kvack.org (Postfix)
	id 71FAB6B05B7; Sat, 14 Nov 2026 15:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7276B05B8; Sat, 14 Nov 2026 15:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF616B05BE; Sat, 14 Nov 2026 15:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3839D6B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:25:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF4E71C271B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:25:52 +0000 (UTC)
X-FDA: 85434855744.18.F49E154
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0F7320005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:25:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W58eZLA2;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794687951;
	b=rewC9IC+EwstWJYAFZV0/wZnLHFj/x4LFcvjEYNG0orTfmk/UFWsg0L/4fzE2mShMpJl4W
	HgF5Ai2GAesuGCOHQuWjQAwA3LMIrr4/Al4EJwAXkg+JPqmelRlrejVilJXOzbYEDDS5Kj
	dwXzwu5INudXdFCBlaZigm6j7P9tLTs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W58eZLA2;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794687951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhFgL5mQ4FmBEnWXxDB8G4YBTGpdQKsK7XBv176IhtY=;
	b=UeGF3IJyYaP04vsKi51BhnK4/wQIxKAWPKtC+ZmRYsRnK8iNrdEdITVBiWqYuXq3U6zrck
	B0xsSnK66vZvbaAhCLoFld1MIxUEEWJJzXuiFLG/kfAabq/xrB2lQ09sTuRLV15vjMSI1K
	vktXycOdXgkhU9TsFcgaTiaEhRRl7Uo=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f22a8515eso264925285a.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794687950; x=1795292750; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uhFgL5mQ4FmBEnWXxDB8G4YBTGpdQKsK7XBv176IhtY=;
        b=W58eZLA2cfY0ftsoVh3fthBtiuHZs5DhHwyTnEly2rIn8Pxs3G7Ic8AlIrubYaqf+o
         oNjyErDqnEu8YaEREp6e/oyQzFDvt9LmAJSoF1Tc+HEo3fVjGHl9I1DzMN5V2Z268bWP
         /TfT7vaqsvF7Exp1KrTZkxu84a/2qpQjAsokIfKYX2ae/lin7mM5nbKPbt2EPUzoUoMD
         J5AcWgBDLfy8lr18Ec5MVyn9Se2PoeXjnXPqXGBzyMYLdDCmb1+1toarpSS3D/6tLRNt
         yeuVqJXVCUlRDDiflfO+FECoiSXd6evocCr+CsjCOH71xYP67IPJw1mmIgBmkxlRbC6v
         7BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794687950; x=1795292750;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhFgL5mQ4FmBEnWXxDB8G4YBTGpdQKsK7XBv176IhtY=;
        b=PS9WaI+T/PwvjpimLy1snKqf+/oC7wAA0ae0PwZdC5lOzem86fVdyq3fw5Sgbw06MX
         oqxiiRz9DtvA/U9EGNMaHO7djcrmVPScbUeJyAMMKXzUZgY/3GlaSxMHShTsS9PveZN6
         fCAFPGKa6PLo90hqE0dthB6yfSLvNHziyTp34rSBgt4cqncI7PYdnSw41LqaAAb8BkB0
         fwyRrkjcbdgDwQRm7+sIJkV3q9gWrFUJhn6fg2CqxBIuM4u3ARc6+/oKtch5x4IDiz7+
         nQH20mdksumSLz4y2sYQIIdi+GyOZqvYqx9RUH8clMdOYGaBmcUhoj8ih4vcyT5WN9eT
         J7/A==
X-Forwarded-Encrypted: i=1; AL+hErH6BIc6riqPL6+cTp16FiGfV6uuagPKAaUazN1/N8CYA3mIVVg1sBRBnN68fn904762HTQMNTfPMg==@kvack.org
X-Gm-Message-State: APuU4Z/m7TGRjy4uBv3GX5CMV6F4Iqmbf5Z1QmuMWHMQMSw7ri2wSVlk
	GGGZ/C4XTrL/kLagL7fPGzD3a+c/W3A6t9nVHU767pKAxB+bSwKUbp+4KVooOY9uKwdpimvkcNV
	za3Nn
X-Gm-Gg: AYBFou1jzvTcm28hrPyxNA0MNDK3FXF4RWLjs8SDAEhANgUquNM49hNME28a2bbGViS
	q/KGcAQbDuAE9bqQKRphR49EqzeqBpRs/STCYHu5OzbqgyW21GfzaS1IH8Pdu8maM8SkeQ0KEm9
	3JQ4YkSp20gGwx4lMnTJkjX9CTsuaXNDWX7xs/JkuZkuV8k1dmTllyiTvQbpIYx4butkw8wRcet
	70Zy8uzAuqjXRgJlSWtJz0LTJlQAM46Gj7RTfmC6vpoC2CiwqYiW1BtvTuJoB/iZGOPkYxsUDC1
	p5VDMCeY5CjBH/3hVvzX8mI9yfJD7m77ILJZkJ21jrIw17knr6JPiEToOH1M+GakFHzOz94KmW2
	eXj/TLlUmKRCWy8s1IzWW48L8w1PC/p/0T7yLRPObkcUuOCmZYRDhiHvYyYek11EfY1scjP8nXq
	BCaXLVkmD35WkCF8s7RYi9BgOBtRp40wRfoqiOFI/hhPkuxflaXfTdYHY5kULQzLI02vwFAJU7e
	rMKViaWobhCdcZ9rYFVAdedP+S2OdQj1VJ5hu83mzLRE1tOLo/X+jigNNu88A7QNCDNqlH4VxUr
	t8kcG0e8CNlRcj0E63xy6KW8K3Twgd4SCRRlLrNt5zdDn6TE7IXMVMSZs7tHbY9s9KVULt0fDLM
	ugixpHmU=
X-Received: by 2002:a05:620a:4481:b0:93e:c12c:f11e with SMTP id af79cd13be357-9494bcd396cmr1068763285a.74.1794687950152;
        Sat, 14 Nov 2026 12:25:50 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d5f3e4sm50436436d6.16.2026.11.14.12.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:25:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
 <179467808112.482102.13365594235443107281.b4-reply@b4>
 <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
Date: Sat, 14 Nov 2026 15:25:48 -0500
Message-Id: <179468794889.482102.14066028910704780583.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: ai6gqfb3foxighzngkgjzqpcoa5qggoc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0F7320005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794687950-335173
X-HE-Meta: U2FsdGVkX18Nm6lgHl0Sd8BfaD1va/hay+Zgm0a3On1B005ywonBZ9x/hn0l3YPgY6D6qgxNQ/8MMgAvznr865xjaMN1UdOkjnJhjwMNP2/gT5fWtFtm8PQCsQuQWpOT2MKWuQc0LIQq+zJZ4jxvK5wmTmb9CRkIQztlbuIZsunWdC89erYKmMJqvQ1DdC/MLh9Zl5wuTkIJ+QFiJJQ2JjZzBzCYM7ogkeZ+4UHH59SXyQQPsx25BoXYVOT+eVmyzCOa2lGvm3LYpJBnYus5kBT0ajk257ex6H71VqBsQkzZ0cAgm3frtXLPQCdkgOG6/qcRbZ2RBDAzfJZfdOyMiMW6I1U86ZYB/bYHjpA+nhdjpFHDKYaF1vROwTIyXdmFdFTUwDoGCYrPXkVLKB6tZaZTlSWy95UKMShZb+sx9BgVBwbMzRChiRmBTy5hYIpKMBcnxnHXz9nJlLbdx7KSLG5weWBPYVRmGjtxrddMKtVWcXX4Lebis7GX0bbYua30pi15lQexDrPeheGyd4SjWQZgqmenMcevGJBvc3IHWNIgElKB+nxCjcqm6gnNTHV8qzOogA69lAkK1Og5JNSbo6b7pfhnzdWcR6pnIbsd8puS8XWmLBciMfZgS4RINmZ0hU2FbfIBcP24X/s4r7WekIJySwxVKJygSs51asQWqlF71nPqhgbnnzy3nZSVuxSwwLuCtL6UVYxyCtZNaLeGqQzT5MaPdu/lvAXmiUiGP0HF5Ru4zxpiV3aXGT6xx0xJvInC7b5AiOq67pNui9V4KAjtY1YLn4DhJfjxEr2QIvZaIRoJ7/tFd8lNxhi7YnxCTvxagVyIPsXHEn3p4CcE07tE8UWgqH2tVDG92ICoIDH1lJ0PGcqPOsy+Yz7WcVVMDMYzybsm2p8XTPESVm7S88xI8scHgX/iDqQnB7jRwuwc8bN/MYueuojz/MjHW2zPE7S5slFl0H6i6YBNGdU
 WIxmGfVa
 RGW3NumuIOYKMI0oBXfTrdzrj7P7oEAqoF9BXUf1nOEeC5Jhn4RovkOdNdaejRt31j4ShFMfwsyiobOJ+/1wiswL7TLJfW4pNXbZdwqClIbI2m2l75wQmyr5Prini52BtSZSTuMLEPMrZJwoQhbezTKNljOcYPeUu86SYin9n2yehZy6p07mQvNP6O34OH9BGf040v8X0UzS8MUoBP6vFVCAUMBpJs+n3La3fRUXxS8K803cSOxe/Fp2FaB9v1k8ltI8il+Jwe14yJOxDJWVqqtb8oTahCUHPqCjuJ9WoJsF6ChmqXwbSd492/xvoq6UJklHmxj7Og1HhBGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-14 21:16 +0100, David Hildenbrand (Arm) wrote:
> On 11/14/26 18:41, Gregory Price (Meta) wrote:
> > 
> > Multi-task mappers were previously unlimited, but that seems like more
> > of a nasty unintended corner case - not a real feature.
> > 
> > A single process is already limited on the number of vmas/policies based
> > on `max_map_count`, so it seems natural to just use max_map_count
> > directly, but I took a brief look at some distros and most seem to
> > ship a raised `max_map_count` (>1 million) by default).
> > 
> > I tested that and even 1 million can cause a soft lockup.
> > 
> > Not sure there's an easy solution here, we might have to rework the shm
> > policy locks.
> 
> Do you know a single valid use case that's not solved by patch #1 and would
> trigger that many policies?
> 
> Ai was not able to come up with anything for me.

Just want to make sure the bases are covered.

If others are ok with this change, it doesn't look unreasonable to me.

Although I'd wonder whether just using max_map_count's limit instead of
adding a new toggle would just be cleaner and avoid adding a new uapi.

-- 
~Gregory


