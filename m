Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A917C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF616B008C; Thu,  3 Sep 2026 10:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6D86B0092; Thu,  3 Sep 2026 10:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603BD6B0095; Thu,  3 Sep 2026 10:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F60D6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:45:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2CE3C0590
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:45:49 +0000 (UTC)
X-FDA: 85172725218.22.C77B3A7
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0338220013
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:45:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=QJesqE4T;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf13.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788446748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHs/hYcfdCQ1ysGE+hmGWWr3Mk+We3imbSb6wYOC52U=;
	b=5Bu/3Xyr6rNKKVUElSYVM0h95nwIGTBckybDFvzwIi0E2/e/EA3trqlF9ioAjmysctJCc4
	FSo+6CajwWAfgqy8SfKmGcTx6GYQIqMd48VzILYbYHEvAkYbpiXHsb1vZm6loDozEe/iQb
	W7/K0KyrXe87q+6HFTg4bpEuxdUWEWg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=QJesqE4T;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf13.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788446748;
	b=niN9bZwoBdUVA2gJ35Jsbbm89p0bsO4Zbeb56/PJFiwXIRr9BBCXhj1kmHM7W3R3CCNuE8
	L4qNSwe7Zg8eaCYlaJFSN8dkEHWWH8azlqBnqcm7qk89kmhwscU5tghizkUE9tpUxE+Iil
	mRSDRVj7qEIlDb3P8KTEmgDwXhKircc=
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 683EjLMF011651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 3 Sep 2026 10:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1788446726; bh=qHs/hYcfdCQ1ysGE+hmGWWr3Mk+We3imbSb6wYOC52U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=QJesqE4TZVDMmqCP0gYnKzQVE38G5Sj1uHY8Px+6ZarWBBRuhH1Fwb1CRJ5tJPRFV
	 tmOiLD28kscOP8nUwRZQsNO/wuT4KMKK12aCBaWLHnxjUqbgUTwmyQBvTJ2mBkZ+88
	 /QN2pl7raeA9OfyGDIqrh4LXvngd7aOvgPf+U75IMT4tmP+CjfZpnKL3Ym4RgOG14t
	 k28ord6f1XO1MU81Az2eIi9VgraAJBU9HpcZgM1M3J0UIfdl859jwgeG0NbUVpFB/V
	 7p2L8VgjrjdYi/84CLpjr044H60KgLgzIYRVIAI7c/vwX2bDYIxq9mAEVxUhO4HVWN
	 LYHu+Y27eWAuA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id BA709132623E; Thu,  3 Sep 2026 10:44:20 -0400 (EDT)
Date: Thu, 3 Sep 2026 10:44:20 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
        ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Message-ID: <apmHuRN-r4gfWnTX@mit.edu>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
X-Stat-Signature: usxqi5qcmybjdsso4ono8tdqyhcbxjp4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0338220013
X-Rspam-User: 
X-HE-Tag: 1788446747-774724
X-HE-Meta: U2FsdGVkX1+IE4ViJoB1GLCz7iCxRDhBvYaWh02O/LoP4qkxiaJ3FRJ+I1oV27zg9rNG2vrvw1EFRiDXs8ytKzjKL75yek+oBxJu82LGgHZEwJfXZW0HWLTpCnTRCTPCvS9PEVoV6yz1bGbsfE3I+A9zlwcRktfzEGeEnCqL6fyNOVi4b8/2yeA+PrRtTmvI1oYed45kqaJSMZ5kCijfvxXHa/l+n8tri5v9thIQgvK56uHlp0xczBrrCVwgtiC3Cuhi3RazhBcBNvumy5pfKqRS6eHn2kBgKfIAf2ZNdRLOVKFY783f+pN+OagPrfcPAgIVArKEYmY7URByzevtSZbqiFm9CpxTPusCGczdVjmVgQ9ogU9tFAKyBh7mLDENmpYSFEZ8WPUqbjvY+g3Q+uaV42Q4x0jHLLoPG20jUkCovPX9jGwX9Mqv/NbVI4oxrZP40ySObHXBkePd+JunJpbA+5KRmpreKoSz2wSBqhYU5yqXbCua9qKMd1wcYvOj1qOwhU1Aek6pTrgntsIm2nzTohLRzsMWJz0Gm8Au1ETYl+Eitlf1IGVfTCp//htSWtcNYOPnWm8U5gcGbgy8kBXg3Nyg2GkYRcIesnMrFpQzHZKtF8uE4nnJTQGX8gxDqVYIHXgAEaNUYFWh1JPf0fnGveXAy2ZS/sArhJFxHmS1Mgocz1AxiEyRUG1jOY5pZpgclE/1AVwBzkGu+rRpO5HX1zVbb2HpOJVa7o+ZS3tciZ74Fev+roZ92yPs6vPL7pdN/7t6/JHysYONMqsSSVQc+zoJBK9HtLvlbzTWybxkevtwFgOCwmk+sPXb8CTDUMRMu9zdFQyHediQzZrgS5vbwug4mXSktHipG/elnOM/sy+ltjukspxp2+aQXmJQJyqnyPr+w11pSlBRxLe5/O4Uz8Vp+pue65ZgNSqsWpf0DPwNOZG+iwMFMfRRUS/Y/OliV3s/XKtFdBaw24l
 nx5G+dqa
 gXuK3cPDan3UtiUrEffJUqZjadBNlX9rr7gBb6wTNj0OF7L95F/+ODUJUdWTB1Fk6NqZ7SICqB8PCYmCTSoIWAbJMigCpdPgf1ABpEpGrOjwnesZhdBnbWXszqcqSJxctUpsNPupHfHITVAjQNS8Lt/UaHoOqVle5CYvZ2eYm9lkDKXEmERLEHP0UZl1QAiYZr23ik6vOtpD8h03JgsdIFUjSJIEcPU5+vGuzqSsYB0nhIXw75NbE+QswQJsz4sY9r/AvMoeRjrPl9ovX4gqbm3Hqd+QCgbyT42rj75Nndvhx3NTm4dvXl+mIgaLn9yBjeFkOBF/Bi2e/zuzXzhAzP2aeH2FXsInCacW3Kmswdr6IwU8hhPm6Ve5aZxWvnspNgNZEhNAO1g2o8fXlA7JSfDKcmpTA3z6urYfRRdRhX50wF9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 05:18:49AM -0500, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>

