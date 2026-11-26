Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E23606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HixL8t00
Received: by kanga.kvack.org (Postfix)
	id B9B8D6B05B0; Wed, 25 Nov 2026 21:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C6F6B05B1; Wed, 25 Nov 2026 21:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BC66B05B4; Wed, 25 Nov 2026 21:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 823E86B05B0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:34:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12DA780186
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:34:49 +0000 (UTC)
X-FDA: 85475702298.14.3AC4690
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 354E540002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:34:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HixL8t00;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795660487;
	b=HscPcPIFrtrB7gwBk9VFojAtoR1nrurzoTWi1JLwq/sr9Xxy+/fc4H0eGSOrMMVI2BlW3g
	3Qe9PpnaH1TaRZ8GGhgjKDg/kkcucuiUgz0a5ApqjRdQ0j3XK0B0BehR2u8WZYe5MNYwlf
	mZc3SccLn9vpJW8h7IW+mDA3kcz92HU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795660487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8J9LgNaOdUC46WHWDlfzHDnkRTN/ql1qdkuGk8pFsc=;
	b=73kaGiGv4UBxLtf3rNthF9asFwrQOvTqBN64W9HFNBRvdxCaRboxAqUFuIR7RbjnJ+9KVM
	t9PcaHQ1SNgzqOqwfk0B6QWmmBRoHZpgZ/Wr7zmozyUsFqTsaeQiL2DuUEhHRdJ9tucl8M
	VCmhYo2GllcNhyPl4768poGGyUXhaV4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HixL8t00;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-67dc7eb1442so7254779d50.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795660486; x=1796265286; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o8J9LgNaOdUC46WHWDlfzHDnkRTN/ql1qdkuGk8pFsc=;
        b=HixL8t00nWtUKWTHr8FZHn2bEN/rMRhuIM1Lg/nRXIgyMIgxmQnaAIzUGdV9F+APrw
         i6dYYym/HmA4W2rSd3xTP9P41cDFXQJyEu/2pAuh1LTjcDtyrACD8oNXmRGBXgHnOQ3k
         Na3IJX/jf+pP+KtWw24KApqj9KLUjfc2sH+mU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795660486; x=1796265286;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o8J9LgNaOdUC46WHWDlfzHDnkRTN/ql1qdkuGk8pFsc=;
        b=riBdSV1rD9Lev8+46cyQ6D+oUk4avjwg8gwrHHDHFwgFO0R0kx8GOFlkYlpCaUdp4a
         jLOhuvy1P5CMOJXJXj/GdSpdIa4UyCW2o8MsrJAjoQ0MGjGrb0zNYDYBbAbfhy1xQYyf
         QdGKWgG4Spwzzj1y1Y5RCdTv1MbInsqnw1oyY7RSwZFkl33koMbexClisGhNOOCSb155
         NxEsB31FHYtLZN3A5CA66eQC5SMTPJx2ePgeNf5WimRwlvfoyGtsujihLsDdDpJc1GKs
         53FEJaHa6fMw3AbnwBzvTqTxF7olzkd7/j6fH27HIrFTYSnq+m+VR9rdwmbR3V1YIBng
         e9Jg==
X-Forwarded-Encrypted: i=1; AL+hErFLDKULbcfMcNkyAItDA9LWWNEfGiuyf//PWTAAYmQzNLyJoQAVLstVUR3ZDzcsYJ+visp1G+LKJQ==@kvack.org
X-Gm-Message-State: APuU4Z/wiHjw40z3o8vZSc5ifjGUawEQW7NGCJBjsIp7xK1pS6UnIoLh
	StuiC+ECq65JQ8Ql3krq046LKmxbCfH9Am46f0+WQcQkCOwsa6rLDS9bCAx75VB++Qs=
X-Gm-Gg: AZFdTZeesgEXFl12VglJsn83GjvXVPbnadigN1mOmYbzI6oAInxgoOMmNY98nts+H8n
	WkDy/jTDQdEkYf69RKia2jSd/+QA+L/OXAPdPW30QVviwNKKSHCKJU0MZHwtQ+aqWTonKCr9gu8
	6P2fK2qblZ8BjPsD7rfy1wuXL1D4jLX3OwSpCSFoQjA47F99lLN5uun8HhHMBFaa+Tl/sIhfDpI
	hQxeN1C1zTc3FgcHdNAenpajA7g99+uieyf+UyTF581nXRnmUABEmg4cBKfV5kBANPCqGDUofsG
	KZPo7VeWMdRsLIUR9j/lneimfiSHV4FAcyBPf/49g/jAflSJb+rLrqRltteJaJHNM3hIM19wRks
	uPZ1/R6NO8QvxNAf4d3BOM3Cf04eH7AYI+4Z8wo+LW2TeahBegzZzIZEOyRcDGxSLh/lORMtbjo
	pTX9GFKHtvnOS+lOa30FAJZpvAsWu5ktFIXjAm6MGD+p8Anp3SqkLgIFep2h1lXL1+rRVp6SAzb
	pXwes7j5+GLGFLWyHFKHKXKKiLssk5WZPNUw/+xuTlFN1joOLyt7NEZNuZI4hAnyHZ7I8CRoFDB
	zKEEuNeDiF7ZKhhYxafJ6FTr3PcRB1bKOQTHoNb5LBHECZ7X/zy3PqZ+Cw3Wna5qMZOIHmIDx7I
	qanTjhTwVf5dnb0dbKQgemHiCLshZi1swXW/YyWjQqh2sBgWDbl2aAkxPoMkaJuVRpkmLejfrTq
	QbJJUiHJpIpAk0bBkiSb8iEgwR3elhAUKPl2snLcFXwugqsEXl+JQThDM9DNEkMqH0pwB3/DJ7N
	e4JtcpNK6cINJ/DIwNkNAI=
X-Received: by 2002:a05:690e:4188:b0:67d:ba77:6ef8 with SMTP id 956f58d0204a3-67df441dadbmr6760137d50.43.1795660486244;
        Wed, 25 Nov 2026 18:34:46 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df3354415sm9646045d50.11.2026.11.25.18.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 18:34:45 -0800 (PST)
Date: Wed, 25 Nov 2026 18:34:42 -0800
From: Chris Down <chris@chrisdown.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
	surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] mm: fixes for THP migration, swap-in and
	device-private smaps
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
Message-ID: <aweawqOejY8Jyrbb@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 354E540002
X-Rspam-User:
X-Stat-Signature: 4e9fduab5xhpq7m1exip8asiyehjzeus
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795660487-771634
X-HE-Meta: U2FsdGVkX18VvryLKcKN0KHb2DzgccFo9zUJ7tr6yR8onu0gk0VuSujqlb4bybFGn+rS1k+WEs7XZ4L/boUOfcEXMD3jzICVBbd2zy6pOEWK1oS3Wo43GL198/zzxLopIZg9Gkxtcs5lW+G1eJuMVkw2BO0q5b4tC8LqgwzBYzhPyCYxG/ygpRKKDe2WgP+XtoqrlFpB7Ou8oz/OMXLQC3zFx6SpZSKCTGRvAlS2XlyGz/VLB6R5146SH8G0Io6Fh7pRmrtQ+uT1laUdrSBBo21zHK2/JY7sHyk/yf0SLgTKFrjvgGXjyvv390y0zlcUA0NDW+GBpgZmy5Rj64bJzsshHZfXhPZPfQzZmYi147Eg6pkOpAKF6Pj5BGA6Ia7reKiDykf7s601MKprRdzIgD/Gqd4a3v+0V0Z9W3Cd1O+WJLi48rHbUA8fXWQnPqVi2XujN7miEjQZlL7ooXUbWZYkBJThhok7qtWVdK/B2FwAS3WOrM1A0siXT2sugCns1RsA8McFMIQ1g7KBsxPpYadXXp1fZBFWC/GJLmqXNlFJSDUIPXisZmJa7P2oeC8m9X2ikG7fCB+LikA6BHhnmumRw7hxsLc5mdll0QYH/56jHA7Tb759HUk31ZgY7obVi6o/OArIvxMHnIkD5fqmqMCqNWE0s4wNDIeG1pFZ1E/WeWlQY0fCnHN1jgL0eS9Q8IdCtoY24IXYkOJI/2HNzd2ve0MvKfAs2MBUhNYBRWT6yt+KMDL5roN5qml22NYWmZIC9tU7ZmeOfu1pE1AF/FcZHh5ZIbsdG5kVOxKyiU9S12wJcPLnS/kD1pKchb+JNR2CpeGwsdRQtOmyRUTJxTCUEza6jE2n7g7ttvhWorNeqtRyi1FB4s/BYofYd2GiX3kDWznonpMdMjBY+Sxr5xj5FxKZnogpedbgKuRXCQBzZPbON77OwJNUAslEY1M5LMRzc5NgFkHk+SAO4LK
 qTLkIpeE
 XmBfFh/nnkSV+CLdalKaTphY1gAXxN4uHRGlyQwXQAMQVsriho+gaV8gH8/iuRF1QLAElPe5DwLF/9sYHIoKUJUCk3Ouqd1Xu+9edlaDm5lWbsA8GOA6BS7rhLEcrwe9P7hVvXJXPhL3j58w97a6jRZDtUELIlCIxIVSl3YsWQ6m0txJ7Gq4GpeBxpRWMozERVPoeIp5wLs2FIQOA/PvCGkK2PI9Rj/BAGJmn4Z2IeYAzXwraS/RhY+PTmst9TYVpYFtujgluVmPUgaTgXSK/1At6LmCCFBfz0HI2SIe5/Kfbt9SSVq5oMXt30vi9zqiwS6TPGol4rZyQ2D75zFsKb3IvquxbpvNnYDTUkfDCjVLdgFD+VgHhSaRo5DdqRxRcBXw93z9v/4BNVgbbPklU/jaa4nH97Oh1Jz3fmCK52dbgNAXTwjq/ux3AJjbfjRcUMfvzWXLYBhIr+GLKYwB2OpbM5zsZgiE1dmZRVH7LGoaJFPj5O5DRtPmCmLoA8NEgRdwOMdurlbcyLNjmKHPjYLT+ZYdOubr8hNYy+ZBxmEZLIIuZxVJEqFEwEZJBHeC2hYZEaFUCDJtprrvVFBc25kxQ1mQABt0PvyfZnTC9lENvvludvdzXD8H+HyNzDGZElE7RRmxDATxSb9Y8nsN8I/uR5nVGqROt3AJYeIPqzaaSaGXnEYbU0vJliZJYxCKtjyStQICxcTuXpSZFI93Zsr6TJG4tZzvHHd17x3is11a4PieVrON5Fjj14g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Usama,

Thanks, these all look good to me. I reproduced each of the problems on
7.4-rc4 and have verified that the series fixes them.

As such:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

