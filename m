Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB1FCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C150D8E0024; Tue, 21 Oct 2025 08:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6288E0002; Tue, 21 Oct 2025 08:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F238E0024; Tue, 21 Oct 2025 08:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6B98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53B2D88516
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:40 +0000 (UTC)
X-FDA: 84022128120.26.A8D424C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24DEC1C000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WvCAyCu2;
	spf=pass (imf20.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJ8O3oI3PxPdSYdHMVP+xUJdXO9FbTcv+rg9gD/qHfE=;
	b=UZvuHKsuk0djWl0c0Bw3u9MCJbp/dvIZ6W7gApOfYPYArQgt/9/0FJQTh8FKEWZF7y4qpH
	lzzDBGPdNgE+pHkDm+d3xxaB5yvYYHQqfSyYx2andW38fRg9WQDmrsABMJm62CGEolXYyD
	nO4HfrBc+2FTRB/qzI3/vz6gbXfouzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051578; a=rsa-sha256;
	cv=none;
	b=EB/e75juMmxh9+BaPffmbR7VUEdsY++Z3Dsx4rdf6idXfhHZGTPrSRhZD7ep6BEC8hH9Rh
	PizpkYkwNGK33bDDfcNk9KjHrNOXSs3u2cikiIk43Ifb02z2/AnDWjPHQofvcEADoj9RtQ
	yIiTXybkKtbsmssZ7XAm0SuRiqhZuKk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WvCAyCu2;
	spf=pass (imf20.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJ8O3oI3PxPdSYdHMVP+xUJdXO9FbTcv+rg9gD/qHfE=;
	b=WvCAyCu2B1oAwKJ1eP6FVYWtHDeiVj7d+FCPG5MZDmyglZ1mVAxnJ+fZm2zTpg/opVLIHu
	/gw/4x43FTl0kCVC7ht5JVegOizAL1ZRH7VIfw4X4NHf97TaKuYHKkKfILK71biSO6Tl6G
	D6bOVso8PBOC6mjrdm4q8QKBGldBkBU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-rnwEaQyWNtmcsNWE8uegUg-1; Tue, 21 Oct 2025 08:59:36 -0400
X-MC-Unique: rnwEaQyWNtmcsNWE8uegUg-1
X-Mimecast-MFC-AGG-ID: rnwEaQyWNtmcsNWE8uegUg_1761051575
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso3170820f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051575; x=1761656375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJ8O3oI3PxPdSYdHMVP+xUJdXO9FbTcv+rg9gD/qHfE=;
        b=EfeMAD1mpl1IobeoI5Bndd0Qwog4cnNefn9o4WBs6d0NUwvvhO3A+1PGJZVEf7KrXg
         pFsxLMu0x5LtZihX928u3816fZW2808FwUHS0f5k5ccMSdJ68shIUnlZLcx+Zw60I4s0
         7VYGrnCzwFjSKL+KZgQ3eL4WKu0b2r2707ks1wloZ2jjqkTiRLAqMx3b7AH6hQCBDkp6
         QaFN2GuBUFnHKlZ/2gu2H9orj7FtGS7M/I3nQWYsGuax6bg4dwh/I2hR5/0i2300MCiG
         0Dy2m9BhTSGydMOBweaNHSU+qNCQHUVoDvSYjKb0tgm1TZak4aOhBpkWvZP7ZB4blBRR
         rEPg==
X-Gm-Message-State: AOJu0YycvejO2DZXISSU2M1MArUe6cmPK0HIU9vG6giJvbANbEs3+MPp
	ucUbkhcojR84pH0y4SJsClxz31zaskEckhEvsmcbzor/TuXI0PnI5RlPQ0WLOv9FUVZlOkH7Rdi
	nd1tQXqmrELAw/GNtotRIUjCGdxP+npIqKyE1Ic/v+hJpKtsf6yEf
X-Gm-Gg: ASbGncuNmfyKTOjBEWppvTnLijFlTTpDc87FB/9M/rfHY0TKMvjS9vsRFN/IPrXPdYq
	Q8WQPC43rw9f9Vx6m7N+/n4ohGNKRADf4gyB4G8d/06O2zM0KdeXV6daWs1gem/TqXnL/EcMYMg
	p1l6d9VlnbN9Q4geowNqzjsDOgWupdpzqR9Yq5ALe12ijCWJgpnS0SYeapPjAg2k6tEHwDABkBq
	llZVMnqpRlMe8LiGOoO7eVvtSS5uGSxIyDQnNMNcDiOHNunTcOvZ2ujuGxasFBpKfOdegsiVAAD
	9wq+SArqQ58YFl1z9NWgHAvH93NFnYqRrrbVu7Z3HgXVVs5Zf9t/YIzlyLeX0zrH+ORmwmOTl6T
	fUu8GO7XsOrCmG48guWmpaQxi53WKrdcQZwzUcVxfYBnYgFiYV2yY6wrxpWru
X-Received: by 2002:a05:6000:2287:b0:425:7e33:b4a9 with SMTP id ffacd0b85a97d-42704a62705mr14069868f8f.0.1761051574838;
        Tue, 21 Oct 2025 05:59:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECa0A/SeCpIiHVmJluGV/YpnUcjGB4T+0tmg/6h2iDdcNEnR83hKR+rxH2jY97xv4J3P/Z8A==
X-Received: by 2002:a05:6000:2287:b0:425:7e33:b4a9 with SMTP id ffacd0b85a97d-42704a62705mr14069824f8f.0.1761051574412;
        Tue, 21 Oct 2025 05:59:34 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00ba01bsm19979250f8f.41.2025.10.21.05.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:33 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 01/23] vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
Date: Tue, 21 Oct 2025 14:59:06 +0200
Message-ID: <20251021125929.377194-2-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gC3-Sk7F_V8hI4PpmyGFVRR38Yqqrmx9PB-2USksm3w_1761051575
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Stat-Signature: tp44qoue9m663rineyigk4uuzm48u63z
X-Rspam-User: 
X-Rspamd-Queue-Id: 24DEC1C000A
X-HE-Tag: 1761051577-193959
X-HE-Meta: U2FsdGVkX1+zg2H4+bo/6klWdykQe8anthajMl8qs+yQ8LAI839gdbzFB+QAIRHSsOmiyKxajW2o+ZNywEyq5Y0gM+j9v0Eme/uFZYh7RDR7s7FIlU10dxVVp9bDC/ONSzGccgXjX3LjQXNHtsbc78HshqRFTfMPptql+vnSThM8yr9hl0yF5Jg1Y9P8S+xLyzRUCDkqZOFf0pR4Hl7+bKh/RUGmWYhOfk6+NeSADj9zDEbWfqStiKSfpBcRJHvMbRol/h8wT2ap0V65TZvMVHugSZ0kbykRF+BobAU/+7/UbUTr9q7myMk7MTPoCwa65BrX7b7HrhSir+CSBjtlG9eUOWnfzt4g2uQ0qIKkT0B6gSEN+h0bNPIc6nxdEdRiMa5Mbs1m2DDnlbFiaF58aqShB+okGbgCYbBgPCaF3xnHrhwTq7Mj5Up5/M2CEhUT8DaKW0p8pyzdF2YvW/hR3iqghoutpsiygqspHjmXEHci3K7KTBF0j5/xAic4k/7OPSytr+xlUva4z9miiBPZYIw1rckchS5oXwbU3GjKOVHrKJgx+VD5JbV5iumtfeJI+PJrLay3ofCxc0GkfNLvbb2GWtszSZ8Eg5X/ytt6c4zCMS+7/qH6op9SILHx8s6GL4llo+UG42jXVAQFaBoxGtTHD0QMOQWidZ7UfQCRvdikG62DVLL1CmQdSW+F+AtqiXK/7Tc7HvpE79brGayZc7KV0+rS15ClXn2m4jytBCbqsakBhdTgqIdU4winxRIT/k8WTosDPGNEMwbzJhpVp0WfYd3jY29D7rrx1bQfx7TV4C1HZPgK55wKaQ9PLrh3v6ycsrGRGWzBsgu0kNFYakqd/xUfLOeT2qyVo1fp8oL0OH8k/TRhR0Xyzg7rntrWlbQyx2GM2hLs/ArZ7XhilIzlRHQEjzD2OBccSfneHc/CrLqRzZJ+Vt1ZRjmdwQikjIibev37ttFgJiQPpf/
 WvxtcWJ1
 5V+bbduej2zIffkSmoV6Z25CpNGyIa9B1G9ZDLmKxE4TW4oO2CsWnlAJy/fEa01vv3Tjo4davCgFQfjV9IXaYxzrl2TkJ6Ylnggybu5YDysa5lbyGMXWUp9mCpvrp7HqgjU0OrCbWNt9XBBQSMwMxuWKhK2R9S62nJwLBE0b+YLbFeIoT8IR802Ax2ymJ5lAV/DPhLFt1xnHdRfxZe2Bb8rDbSK421lfYe0skOKkOR8N3x3uHzDmRY8iiDm+3MVlwGAKECtWhG86K7mKhZgF4BUFT8Sh/CK8qzuOEhuXj3jLhTrcwzDvBMH4KSTSQWvian7qHrXHtqqigM4THZeqsZTW6lVPWx45SdjsM1FMe/02HbyrjosmXIMF9nK4zFUarX8MkYzxxGBu16bBZFs9uoUdmePgWDOK5XZBPaUW1mLXOIL0Lj5tE8yCl7UGlTB+disFZtSiInSM2e0+81yT3tzCabbND8f+i61CBOCIcpsGpXcOXKP11Fy8z2le/wiW36FFkkK5ioBzbATRBZym7ygByx4Fg19KNppOo9hVu/WzgkwFq9URrihhY1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we're effectively deflating the balloon while migrating a page
because inflating the new page failed, we're not adjusting
BALLOON_DEFLATE.

Let's do that. This is a preparation for factoring out this handling to
the core code, making it work in a similar way first.

As this (deflating while migrating because of inflation error) is a
corner case that I don't really expect to happen in practice
and the stats are not that crucial, this likely doesn't classify as a fix.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/misc/vmw_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cc1d18b3df5ca..2cc34c4968fac 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1818,6 +1818,8 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+	} else {
+		__count_vm_event(BALLOON_DEFLATE);
 	}
 
 	/*
-- 
2.51.0


