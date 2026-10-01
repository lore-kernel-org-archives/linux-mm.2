Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 595E9CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 16:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D4C6B0092; Thu,  1 Oct 2026 12:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245396B0093; Thu,  1 Oct 2026 12:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182966B0096; Thu,  1 Oct 2026 12:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB6B66B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:09:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 884AC1A046A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:09:16 +0000 (UTC)
X-FDA: 85274541912.10.A765C33
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C8EA40005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:09:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVBbfxux;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790870954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2WhXekatGyTe7NNA2QDA9cNUaDy0yKLA81NRXFUVU4=;
	b=s6ByQ0Xn+z8XDb3b911qyEA3jMCscYf+tf3hJEcmKHCmcQX+VfHhE3QZz54XnSu8EUMz2x
	0GU5A4MBKIwWN7Fd3egzSmcv660j9R6E/O9ypJjd6D2AJvgsddyUGnJBp7eWhZBQ1Vl22/
	kbd7MTSxhKGzWsWKihvucxDLfmvzGKY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVBbfxux;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790870954;
	b=IEViZGWIRwpqPRSBq960i/q6DCeWfAXlXZzQRQBJoQE3movX3lL4fC/3eBhT75PkvVQz3D
	Ty/CtT160BWrn7TWBtEXqsnc7wwcgAQtZm36RaQCaemsZXjdMsCJHGcKsijlqFu/zoEj3I
	J/VUFK27icwhpDVk12nrIGbn1iK6hO8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m2WhXekatGyTe7NNA2QDA9cNUaDy0yKLA81NRXFUVU4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790870953; v=1; x=1791475753;
 b=QVBbfxuxgsYOrmjIcMSb0o43Duk2Mj2lXbjKD2+nC0HWiqdCb2VIC5EzrkeCyoxIMnRwV086
 8TxEEnCIaDp80rwWDHlKGgjqVJ/04q3CTGGEx1Jy31O2Af2/myWegCaeMiqGyadEcOdGFWLKCIe
 1qqH5X0KwsFlAMkNZPZaQIzc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 991aeb1c7099deb0;
	Thu, 01 Oct 2026 16:09:13 +0000
X-Mizu-Trace-ID: 991aeb1c7099deb0
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page init
Date: Fri,  2 Oct 2026 00:09:07 +0800
Message-ID: <20261001160907.25429-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-7-songmuchun@bytedance.com>
References: <20260929053231.66085-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fumpp9ztnqay5wu3px7qo3yfduhf7mzx
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C8EA40005
X-HE-Tag: 1790870954-641603
X-HE-Meta: U2FsdGVkX18nz9S1JuMfYlcIKGlkG0kTJyqEdPjaD9+4o98GWsCv2UpOmLbabjLeVu5YmlHNGqnInhYiTfUewqX+n0sLbsMiGuDE05jisqsgQXSkn2W1BqhSXgdP3PRRZhCFd7pCjMNd1aq2nUNGIGIkDa1XXcnbHA9qnE8Wt0dPJJg4jYJUU5P0DUg7xYwLDaSjAsi8EHbHzedeY3iP4CI1lXP73zw8NGCUwFNSHnse5PYp05IhwugCuElLElzdVFt2+bkNVNQuJpwNUFGybTAKvs7AJwFasG5dASCdKGlpSAJTQhhikBdLsTAocOuhPJLwMNvGdv6GY4ki27tiXYtjcxCgEghQmJ1McDf+1dPURZO69InxDVFB4hSF9E+KmG9wHNuiRwMXhVIgSFssFR6GOJH/9fqPujQssYPOuTc3eTslZeqwGrkTpPUvMN/BlT1fk+/o4UnOJMsGl8sm3x/EZkboksR6xnNY9iuAy6eGUHcrWNnF9B4sVSyipa+ZLM3gHJfa40UwKQN27puHI0PiTdwlopfIa60t4SlWVpw4dQsOFQ/DOXCiMf9XD3bYSF+dJn/P4Yw1u5/uDamyI5n5vujk1Lt09M9NlbU79DUNBZx9CPUsnPkIqQbMwX94+oFMZOyABgGl/aOd/NKwpk1N7pmi+w/OS7GDUvcuS2s4ga3koPG0HWgSLCzFBLd5OV2+Rh2iqhtQWl1rPVmRSq9QAYP3EaKVDtZQ6wb3F8WVR12JI8lyTBjf2nfnpTFHYLItKPfZJZOMWxCSDP2ZqOokM7v4rlIX6rHivKw41De02WZb76mDKYwwIUxIByR1qYQqp30r12Gj1tVla42FSOUa0BYph81SQZL1WnXR0v45shp6sTlq74UeQddyMwVLPVFAjcuKbBrA2YD+YjiM80AUa77l209qLqkaa7Z6Su0QYuyVOlOX3LeD4CT3vsFaGUTqzSt6aASE3T14dzl
 yWoy0n6t
 UAvAfXRJT0Vf5+0G2dCsWk/0A41HuZQYhcR1KNzjVwN/utfqOde6A2wPSlybFCH9ND1wX7uGdnm5iBONN8vdWb3I6y6QHnsb28ak7rSdxEFfCaaEpvqxqFNam2ZWuyiOnhoqxsTNMOESLmb/pJEMReOJnZsh0yJqkcs0DbkASGPlO44rZBmhvs0Z2lifM+dcq5hypj6fgpvahEY0Coz2g1Wpsgc+zGf2uIThIXLA5+tQ+9yKl0u1Pj4FIs/8MvTU9al32S1CQ7qrPzKUHdtpumcp/Mew8Nfsk3rVaTmSCTRiKqLnUeZXRi0qUh8ZAIUiJPXKG2MqbnTY46wIupLhAR5z552jiJm66Zhs7fIXOEv5URAGKZjAV9IKIWQW3kzK1bdwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
>For vmemmap-optimized sections, tail struct pages may be backed by
>shared vmemmap pages. Those shared pages must carry the same page zone
>ID as the struct pages initialized for the section.
>
>Warn in __init_single_page() if the shared tail page has a different
>page_zone_id(), which would indicate inconsistent initialization.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

Useful sanity check :) Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

