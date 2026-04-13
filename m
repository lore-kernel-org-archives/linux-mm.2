Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B727AF531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1E76B0093; Mon, 13 Apr 2026 16:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9F96B0095; Mon, 13 Apr 2026 16:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6A96B0099; Mon, 13 Apr 2026 16:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE176B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:34:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADB0D1402DC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:34:17 +0000 (UTC)
X-FDA: 84654684954.24.FEA9E19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F05BF140004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:34:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ueKp/Tc3";
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEQCuzSCb2vBeHd2l1EaS2ZwBTQQOQ2fqQBY6ZxseMM=;
	b=fnCyE/eja9TtEk8LHj3u22xHbDRK2ZqhJNrXVTHOFnYb27qWds+p/m892SIukF6P9bI6GD
	BdGAcayqSn16PDmwdk5QHGY/lJ6bXyD8i6SP/YsK0p0reF6p7VIknJ33O/iufH2RwZmW12
	LLhKvHRSs2FNQGlqr8mtnLZL/yiU9wc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ueKp/Tc3";
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112456; a=rsa-sha256;
	cv=none;
	b=K4fbl7CVBrOF0uKna9YHnSYAhWajMqgyDRuSdtDguckgYSqnn73Ybc5pkU4xxwbxRN2F80
	9ZFX2xVm+o2SnMABuwx116wDyBIV9kYjELC3xGdX3bIJOKaCI6FbGMznzkGtyZiHwgrHWZ
	/p2DccNo5NQt2nf6GW9nNK7fDzjn6kQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 614A961339;
	Mon, 13 Apr 2026 20:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5340C2BCAF;
	Mon, 13 Apr 2026 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776112455;
	bh=udQmhbHAYKfxARhnBiFmlPPjAm5aIDxgX6FrYs49XaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueKp/Tc3D2T4mj9KONopLzkmpEcHbY3/kRGZG8SfqhL0L/aWP1ghxhxSVO03Ua5mE
	 yLXwsiAenxD64ayJqoXfs8iBRWzAhqWZx+giUMaZ1iF2Bnx4m6ALNtlTwi0A7newGd
	 I11xXRhvr1Geih5+J41lYDYfvA0fjuE85t2jSJk+D6EnfQjbLvYgHW+RmvM/XyhtCQ
	 Ohh6PQSqRU31ugGUgxooghMNNshX6qSmQgpWHwIUAmCOeY4p4GXXuK1cXFHrr8XVCg
	 usqs8p7pLJ9h0/rJVkm72u93GV5OUM7b5FdOEjl/B+MV+OFBfEttg7HY+3kR12WxY7
	 9HLpsZUfy2QdA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: david@kernel.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	dri-devel@lists.freedesktop.org,
	jstultz@google.com,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	mripard@kernel.org,
	sumit.semwal@linaro.org,
	xueyuan.chen21@gmail.com
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
Date: Tue, 14 Apr 2026 04:34:10 +0800
Message-Id: <20260413203410.13079-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260403092028.61257-1-baohua@kernel.org>
References: <20260403092028.61257-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F05BF140004
X-Stat-Signature: sus3sb5yphwirb9oqxgo5xrynkr951od
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776112455-986688
X-HE-Meta: U2FsdGVkX1+gVwkoXsWcFybrRMYUfQ32twFR5sW865Y7hXZv3fYT9U/TgpfE4Pfi1Fe9kVbUl3hz5kJpj4MlRtivV8JfovNhf3gGi6O37sUzguckJiqd66+PQMkQpBArwCOsQiTMaH6ztY+e3KEMUdGzGeXNERPGhrxE3ZeHDHOkPcXbsOEwNef6l6f2L+8fv0h47eJUSnJYdeAxPyHDE65o3lqYDN1IKSrzcDl9vn1064i4fEicpfeYrPIYRm9B2NaKzwFXV+HcaSvJTeqeFc9yINO90bq+V+tyzBpw2ygIC2c5M2Rvem25d5CLf2Nt6LBx0EAmpfAjZTmOfOQkqdAtkmSCKczk3y4h4SpeneuZnn/Gn+CeYSEifLo+zS98468X25qy9jUjTeAQWgbTX6PZ+Yyrmq6hW931P4Bwxh7QDodRRZl/gjR9CXVg1IS4zFy5sUpDnRu+HeA4wSyXWYdP2qfW+AIwFUW7/58035dIIKIc7IVExEhn5QDerInYylr7LsgkjADtCNUCfiFnr5u6R4RF2pV3dt6M7VsZgTCuwdwzBLvEeftDn7pX71u1CLHVCWQ+/4pg14MqvSvHb1y85wwtjP0FEDkKnMNrgiIBmLhuMBjCxNn+Y8AAf52OX9GlGaIjqN983QB1GPxqLjInFi+p6cAVEYF8guIOCqgNjfS7FFAi9bN2KTsqSMeSZTQM0+451PLeB0uaEGqW2rOP7F82Fjf1lZ7VeAVBN/C6xzegKFgfW0eB+gUNxXGB+7mH2EaDy8FHHrMTeBF83Dh+1/+hkM0xXbC5FPZ2wQ3RX9wFRTxvqTtXrI3EsIB7FTO048NiipHGkNOTAeUuiDklSwvQEW+icJvo+KrqmQzl3jQD6mAbWS6W8eUAFINEOfyXe87haLv9XDTUWFVBdUqA7PkOUMLKiCfmQcWgQMwWXoEid01ZKLQ0na+kOkcnHi4iJ3TlnkQOzIOpFss
 7RCyM/lz
 7eVfrranS90H7k4MQklFRjS5OcQgn+aVjtydrU6V7zH05hT9BNp9WrrZitaZ3tCcVYdThd891doiwOTUdZCUtlDX8LwQYyrbO8H7uC/L3zuTF8Yz+IxQAG0SpiIRLGPW5rHFpMBAGoTwWW5vN9EyeDivqBWAcYgBKMkvjrNT5bIvfsDs3Un2Z5X3ePKKeV14Isj1R9zcL4mceptkqs+5afJdKIaqFyPDQHFQDLG0vw45iEDQKFuHbiHZacULvk6Z+6YYio1WHvFueFpqfHrnAqiUUQwimBSrrlJOp5u+j+HOhFNGsgVg28NZb8ULmZxFTfThm81pCDMlTVLRdIviU8ctorob4S7xoNG4veV3ZYne3Z3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> vmap_page_range() does flushing and it has instrumented KMSAN inside.
>> We should follow same semantic. Also it uses ioremap_max_page_shift as
>> maximum page shift policy.
> 
> Not quite sure if vmap() should follow ioremap()’s
> ioremap_max_page_shift. If needed, it shouldn’t be
> difficult to do so.
> 
> I have a version queued for testing (Xueyuan is working
> hard on it). Meanwhile, if you have any comments, please
> feel free to share.
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 57eae99d9909..8d449e78a07a 100644

Hi Uladzislau, David,

As explained there [1], this standalone patch is withdrawn,
as I have moved to a series that addresses a broader set of
issues.
Sorry for any confusion this may have caused.

[1] https://lore.kernel.org/all/CAGsJ_4wCBeVfyFraj_dRdsUrSNqDG5a8SO9C3=PFRSt04dRvGw@mail.gmail.com/

Best Regards
Barry

