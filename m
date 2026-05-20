Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E264DCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103616B008A; Tue, 19 May 2026 22:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAEC6B008C; Tue, 19 May 2026 22:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32726B0092; Tue, 19 May 2026 22:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A736B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:05:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC611910EC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:05:05 +0000 (UTC)
X-FDA: 84786155370.01.27BF56E
Received: from mail3-163.sinamail.sina.com.cn (mail3-163.sinamail.sina.com.cn [202.108.3.163])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FA604000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:05:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=SmJhUrIl;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779242704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+Dn47Ptpimf47RraMfR6SjNvaSUAttZx7qDnXD4Cvc=;
	b=jVkYCQ37McsVWBGGvPVAaJePrkaP6wTyOsmivHV5Wp1Qniz5iEwErrC1+0ryPkV3jGaRPC
	Ai3/aa+YHNUJQ1UhpXduzNvB8Pmk4W79Kq9BUepjIXzt9l5kzz2+hlMEf5IOEBauheJqgy
	HoQnmDUFENTCY4aJrm3yFLEAr+K6OUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779242704; a=rsa-sha256;
	cv=none;
	b=wIS5+k6xMiLTuh74hw/oX5MAvn2Udwx9RMtDdQFkovMJY8lQWVz4AAys9ZEftUV0zzzvqI
	NszYCx285xoIlU4Bk1h5+bNalM+BjiQG5YfPY3OLm1zyEcrooxbnEw1m1/dKYkPdChry5Q
	0+atHrZCLOV7a8q4lRhHGbw6aYyNdcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=SmJhUrIl;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1779242703;
	bh=y+Dn47Ptpimf47RraMfR6SjNvaSUAttZx7qDnXD4Cvc=;
	h=From:Subject:Date:Message-ID;
	b=SmJhUrIlIuiY/B76m671+P2NgzylX1zw4Ou+8JGeFQXE1yGJYN+FFHw+iZW5efDlx
	 LNOLgzavvngY25HkQORdlxBXvbFkFmD7ZdtyIKDQShY9/irtdYXafzu+it2g19nS6U
	 DgX7IVYL0j9eq8uPOZW4Z0I1z6gXNL1t01J59Suk=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.34) with ESMTP
	id 6A0D16C7000039FC; Wed, 20 May 2026 10:04:57 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 3482106292027
X-SMAIL-UIID: A71D656A8CB04380A569F9ADCC051F29-20260520-100457-1
From: Hillf Danton <hdanton@sina.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	surenb@google.com,
	jack@suse.cz,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page fault performance
Date: Wed, 20 May 2026 10:04:45 +0800
Message-ID: <20260520020446.854-1-hdanton@sina.com>
In-Reply-To: <afNM-gIqxpyJ6ro7@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FA604000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 53ctw19z89yhw95o4r4orxzcotepej6r
X-HE-Tag: 1779242701-817147
X-HE-Meta: U2FsdGVkX19vmw+SZhKAXtll+cjfmablHRQbMIeULqZzw8JydZ3j/zaEiekx50GUO4G9yaoNSppjR5mP+VUiRNtgk3mJLeBEkz9FYdf627ifTpGrYBmJOUsJMEOG649yUxiOsuyhK+8auOV6QwJtY0Pf72yw69Q0cBgOKnS+sh4fP3vAKbScBk11PWoQEmGwo2o3ctXSPp9pT5dbcCwpVEVktTxcq55120LmwEZRL+pQmQFPPsgr7Ej/BZJm1DJkF+Dd7QTLnk0IaYX0zP3r6dvqiwSVQchaF9cLtXxUUZcuh2PD5Cv8/QP/dHw/UtXAuXxhgmioVTwknww4PbNQyCCIULLykES9R9cnCWRQluqm4EXac4+NcP9/vEe4ddr4wiRZN4SjXVmouEQFBAQXBKidg1fSjyJpPjNeLzgi2ubtJMXBGCFS7IkW6u+nL3jwhrZ3EDJe/WimkMrPRQRQ+XTAHcZSbiQqLF/R9f7JgWqqCTNSMIuqBJ5ddnB5pDnlR4j1IhayBqnb2QIczxQiJmLOf89lYNvbYE3tYInIgkXqpyWwWs+wI2AVAtpjq+xQG0IU5wwKUdnaHbT2sELo6+x+ip17k5EOuZUWeTmrPEHcQ0lHBjZKbTVaaxl2B5KuQulwVx8fKLLT//YNP5QiwNFOLUDp8xB/WeWjGZq2gy/tZIKlwfSxNvUxZvf3Jeb1++KUER9G9nwklgXkS66Ki1BuzM0gAAk4JBohdboFV5v33AWnUFIugdu7gk+SZRz63herUUknFfOG1drH1ZO1bKSMmDC4IPCRvlA5I2x+jS7EUcDMj2H5DsW33YmLU3yXl3SgKVbx8qh1seAiS0FcEqiUjrBIuBMQLRMJNCFVmNDjx4Xu0g4ta0AObWmmgiWPDNgNi5ZWkX2uQysASzo4MdgPMdQjVyuW2cpryeav7JFlDRGVGqYYK8mce4zTIzSzJuPPYQQdEjGjzdk3wKU
 fvkSB5Xs
 u0kfXGoF437N2r+dlSNI+d5Gae5YDCX6MXSLtcMA5v/UQ8yk6/fXVAQAhcJhLC50hqjLakjXT3smz8rHHRDh39jTGA8s+JfH2oSsklMMvSaWUE9x4/zEdWvzIhupkkJXmF6Mg3J9+gcdEJ8q5K6HcZL2Gkx2erD/cG9cbE7EkNuMkMBcFDaHb2PVkqWVfJhAcSqKDCwg4W96xIC3z5eR5LJEOFNsdel1V/unVP6Hhi3sjCRs8C1SVGpvHOC3NvT3u9859cf3E/8cUymXGD2uWCe87tUVKciJwbqOvyIg+RgTU07Hzx2wcJEX+V3HmK+BqxGIXOaASjkyMol+WtIbW5o1qfTPzXxMYqes9lOXWsiAR0aM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 13:37:14 +0100 Matthew Wilcox wrote:
> On Thu, Apr 30, 2026 at 12:04:22PM +0800, Barry Song (Xiaomi) wrote:
> > (1) If we need to wait for I/O completion, we still drop the per-VMA lock, as
> > current page fault handling already does. Holding it for too long may introduce
> > various priority inversion issues on mobile devices. After I/O completes, we
> > retry the page fault with the per-VMA lock, rather than falling back to
> > mmap_lock.
> 
> You're going to have to do better than that.  You know I hate the
> additional complexity you're adding.  You need to explain why my idea of
> ripping out all the complexity now that we have per-VMA locks doesn't
> work.
> 
Priority inversion can not be avoided given a lock like rwsem but the light
at the end of the tunnel is proxy execution. Even though I suspect it helps
the vma lock, a good instance of paying the price for inventing wheel in the 2020s.

