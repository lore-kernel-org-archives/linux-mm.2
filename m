Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2114CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA3D8E0153; Tue, 14 Oct 2025 19:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B208E0041; Tue, 14 Oct 2025 19:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA19D8E0153; Tue, 14 Oct 2025 19:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17478E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:15:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 609E11A06F8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:19 +0000 (UTC)
X-FDA: 83998277958.22.3A5BEE5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D1A22000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tj0+LcdN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760483717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2xV6N0kbS5NJE59pH+kAWJTSreK8cgXqd31Kd7F88k=;
	b=ESq50u2lXeW/VmtEDVROZyZbedLBzUo+5PKXVj0Kx8zuy+CpPUe1eCi6Q3Ng8q9s1qoGZe
	voVg5sx3aCeq8GQoXq7gMf0IsfaYPQgnG0OKzcVFCE6b1sokOO6QDbuo6lK6vtMOyvsUQb
	WdccY1oP/mevR9JGB5IwgcC46xYM6zY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760483717; a=rsa-sha256;
	cv=none;
	b=JNNr41oBTzrx0aZ2wmucuhWdSQkocJa4dosGNPAf4gn1lCrXCZisSgE7QFgThheMIMTocf
	N6vBxfagUD9KZIy3y6MDIz6U7EWVimsUFPyALtn1iP2T3NniiyjnnuSHCl8VOoM7uguJee
	wrXOSgReq8+kKRTZKHRE3zo/EQh6KOM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tj0+LcdN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760483716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2xV6N0kbS5NJE59pH+kAWJTSreK8cgXqd31Kd7F88k=;
	b=Tj0+LcdNhB8y7jqA8PTCBeOJUl9G59uSTlWSVDorpxUsK6rQO9hMo48is2LedZI7AhhY/u
	iDonPCimeJcGh6Mn31JzCScSij8gHz/KOCllbFhyR8bdpoqdja22K4z20M/VRwL0lRGoac
	2ucOqixBRYwa3xAHTfzd+inULjOm/sM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-4Q1VVyHQOpeX1mbA7uVimg-1; Tue, 14 Oct 2025 19:15:15 -0400
X-MC-Unique: 4Q1VVyHQOpeX1mbA7uVimg-1
X-Mimecast-MFC-AGG-ID: 4Q1VVyHQOpeX1mbA7uVimg_1760483715
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-87bfeecc483so30830806d6.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483714; x=1761088514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s2xV6N0kbS5NJE59pH+kAWJTSreK8cgXqd31Kd7F88k=;
        b=Av4tBZP/mDWZjXjoY9ZBcVoKxQZdonbqZB99L5Igc7cOwY59JiVTgEJX/sAlVAdhjs
         ivgCZE1U2A5aZ4tN7Tz8yfk9A9WX3B7HtdBGMai+VqCPxbflbSghAlQggJs2b2iJbsZ7
         t+1HpaVOhSV2uCyBfkMW7ns6/1n874FCoybrqBFZQi5ZpUWE3t+BKLoqUjKruOWdP0Pu
         9RsP+3qDXw+6DC0JRtH8Y9nIni0+oLMXnAIt5ik1sWuhrEHefQ6lXyNmYCc3w/iBozRb
         +cafqLFtJjcUTAbbNumFRW3FDj9uR7pUFlghxMLP8Gb5vaK84un3IePHN2jJRBsV3uwl
         Z1jw==
X-Forwarded-Encrypted: i=1; AJvYcCXhxBvDcJhQsOrp0qtLhXishbBk7sE/Ti2xItHoofCj1ZlTtlMqEFYy98QJGJmLE/D+YEUi0bhf9w==@kvack.org
X-Gm-Message-State: AOJu0YzQoVNXydV4Bkf+X+q6OdX4DwA6tOs2NPUeJCIjIkzDB4QSxqc2
	FnCo+LRPTeHbV5vf3vCMTaOWjHL9P7iEIVokdbvt2S1FSoXwTCfmhI4eyRvIj70AkGe0Z63KE04
	i06YGKsTxoPQ4NILfVtm3egTtnpdcNh3MwE1GYVVcYKTIvXx3kSeb
X-Gm-Gg: ASbGncvmLv2iq+IYzAZusx4PredmiMhk7CR34pSaD/5z40aLqLKac1QCmfJmCWf8sTn
	5hY/IoeE7XbxZJTbgRdTsLh6F9cpE9juPc21aU+TZo/lujNaW/1/eJ+W8BSm3gjlhIvNFXIXHRE
	nX0QCHdK6ex5I+POOBtZkr6i8ysT+HEPtZHtwmcBUYkkBVYPDe2SXa0faGTDIucCLHp6lXUrsSp
	XDTuV7yMzUUoL/QTgz5Eg+lV1KxxjS/kys8rLLmu8NBhXD9iakC3NoiOGGPyLziRglX0bVcchIF
	Esjm4B/TO0Ef30Zrwy19fmq0hdIPXQ==
X-Received: by 2002:a05:622a:4c6:b0:4b5:eb7b:2789 with SMTP id d75a77b69052e-4e6ead4825emr386564701cf.49.1760483714553;
        Tue, 14 Oct 2025 16:15:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOGy2mNK8H0gignpUFn21rppQSZq/KNciOWvEawmjMMdx22cgdQyf1hWTUzQTj+5o8RND3kA==
X-Received: by 2002:a05:622a:4c6:b0:4b5:eb7b:2789 with SMTP id d75a77b69052e-4e6ead4825emr386564001cf.49.1760483714028;
        Tue, 14 Oct 2025 16:15:14 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1280258685a.53.2025.10.14.16.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 16:15:13 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v4 3/4] mm/hugetlb: Support vm_uffd_ops API
Date: Tue, 14 Oct 2025 19:15:00 -0400
Message-ID: <20251014231501.2301398-4-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251014231501.2301398-1-peterx@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ya8WDdHqsWNnOdXX9PXYWf4Nb2RH8OwMSR-dbtKbDQA_1760483715
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D1A22000D
X-Rspamd-Server: rspam02
X-Stat-Signature: kzkusg58fkaqjhj5fmxcnq6yzg394qqn
X-HE-Tag: 1760483717-409367
X-HE-Meta: U2FsdGVkX1+D3DF6i13XDdNdl47BhJuArMMtM6DNyIct5ng5zmTW0hOMYvMt3r2BbZHux8cFrqxXE8aG8FPQs3Ht/YH5HJDPyI3yp55mVeMWNEI/ibwfLjFJ6O9U2oEU0GzYFlJqOXxx67ZkdzCnUJjR4qp4HKHAHuJl5a8eAKMZqQ2JH066ZvDnfuxSF0OWql4SXSdYQsWPcwKsZLeClo+YYIDgL+SqkfWwdgJuImDAj6+lAf4qCD8iDeCy+MLdAJZqRIiqxeAPKP6vYigchDeUiX1Q2Za4eh+XnxDbOQ6LLNNn8YKLuJme/YpWP2glBldXk+RFmCxQbyfULkeafy/u1SFn0Xp++1Xt5u8Ad2FkO4QHtpDUtlYzIk4WSLnfQDt0R0PxuyGCxyK/xZcrE3d4Phgi0yHHAo9EYw3IV2jPbEsDQ4baxbsHsHHGiuZqstr2U5nPAFZgQsNSjgB6KKypN8LGVvHomqxTZtY387+oD3zjG/KNn5DscSH+emSNFaUa8M3+AHn9TyFg9MVwzufra4qcj4nx1EIehBCWBbdyO6eHT7QXaVAIzlmQLAxgmVlRbuL2ldEDe9wJy2shcJHhkbs9jsqqEZ5V7ePXbMQ09RM81xfBaATpU8qw0C9DerQTVFe53NnQC7J/rTtthx+bOKfy3iSm6n9U+HCO0HWO+1mpDqgIb9B6c9Wj0/snYJXCQrsR+WKZBIgiKOJJICexuSiaWQ5hn66PjSk/mAgPUgks7O/anVngA+DP+vreYumTD8zIGwUD+/OJST22kMQRjwf70JG7Ziz5g7YerijnbiuB90P9LyQLuGFr11l/qoDyGTKLvEuyTUHsA0/P9vbJClyDTg47ok9o17D7X8SpA5uMLqJR/LOjUgZuHrCqCqTUNELETY4JY5hval1P1sYCtk4PoP2KIInnygm5FxjsP+j2Hc6hGAuFnaJlL9c6RRRkLRiS3V6bQxpfQ8u
 iKpP/ww5
 FvPfmPN086glkeWb0YnPVwPI24BTe28TEbLT0iA0qfa81+8m5XJ59kvlOaEFfMKNwr4h9hAWfgncywK5SULkY28+G6kBOVr9qEMmSbn2Mt+Oz5H30D6gpAmbCSoUAzs4HP5FlR0RnCF4VvpUBEGhZzBuSLbSozISTSoI+rdK8U4PsQ08zPGql46eSBmKTXMRVXSrKXOWeGWoZRNLacU3DLJvhP3w7VITjNDQ95Ha0Sl2vHu3nPJEWOuiEDob295BcP7zw2WiqXSZBLrljH5xnmoEU2sq8Z87Ia5PZNAslegQwMMUHr8ut6eRWro+hRAxqNqX/LGrkvJcXhGjSEfWuI5vv726kejCW1BVTGdefjo2FR4PzeAdg0Sh3/9D06HrAA8kULSLhPA74Vkg+gyJMBFXWzssiolnjp6AjdXjCETQ/fKAwW3JowUWZRlbkPMrPGU5JhEzIUZZnNlCtJ4q7I90lvyHWAoTLSdBOLfY9UEG3pkCf4T86NFRXQzrNVZIFD9HXt3E2q4XiiQhyJ+tFHHlHY1w21sdwU19/EUDaz7PKH0LyACYJn2aQEFlzTI/gLmLEsfPrqfGF2MJnOnxmXlXiLh/bMUnPCORbdosgtGHBIBMxyfXJkuXF5sYTri60XcNW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the new vm_uffd_ops API for hugetlb.  Note that this only
introduces the support, the API is not yet used by core mm.

Due to legacy reasons, it's still not trivial to move hugetlb completely to
the API.  But it will still use supported_ioctls properly on the API with
all the implementations still hard coded in mm/.

Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 657b9facba280..ad98876d338e5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5503,6 +5503,21 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const struct vm_uffd_ops hugetlb_uffd_ops = {
+	/* _UFFDIO_ZEROPAGE not supported */
+	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
+					BIT(_UFFDIO_WRITEPROTECT) |
+					BIT(_UFFDIO_CONTINUE) |
+					BIT(_UFFDIO_POISON),
+	/*
+	 * Hugetlbfs still has its own hard-coded handler in userfaultfd,
+	 * due to limitations similar to vm_operations_struct.fault().
+	 * TODO: generalize it to use the API functions.
+	 */
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -5516,6 +5531,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
-- 
2.50.1


