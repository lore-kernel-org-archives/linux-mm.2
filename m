Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13B3C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF136B00A1; Tue, 28 Jul 2026 09:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98336B00A2; Tue, 28 Jul 2026 09:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF556B00A3; Tue, 28 Jul 2026 09:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8496B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:25:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1618D1203A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:25:19 +0000 (UTC)
X-FDA: 85038256758.26.68E5011
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77A68C0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:25:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaJ4jUWV;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785245117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	b=drxc9ZO2pZVzuP5g1Ti4NfaNn854/O4Cxh2tzYevSpNbqqmgnSNcb1mwkE5TCDZoRWat7i
	+ZIzbn5PNLJAlf9cATuD+gpfbtwqpQNJ9+sUZ/tEaxs2USIvt+umLY9Wu1XrZZwDFg7Eof
	JF/li68f41SN05yW+bxaqi6vg7/3q5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785245117;
	b=Sulxll+XAtPwtBw2zoWFxRKOGyGUYt4Mi/UFqQb+ZJRRVHvh4TsdqPTF6CTxvdxjkcx7st
	za9Nyijo9l42jrtGqtS4XBU6c4u7iwAEhIJmP8BpzOmqgooV1nDOiZaof/Yxa+9iAOSjq4
	rC/TXh52apQyqEAfJ77b37B2ZoJfUSM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaJ4jUWV;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C7240403;
	Tue, 28 Jul 2026 13:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3936B1F000E9;
	Tue, 28 Jul 2026 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245116;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VaJ4jUWVuOmuzpDqjmybmjd+t76vdlUgJE4E5RC9QK/aLvtmgtBAF7/Jgny7U+PT8
	 7zG16BN9At68+LTxJz+jBbFmu2bS3Fl4HHMk0ewnQeC/pVVJXVNDSoHmpAqo00iisl
	 GuEUmHWXHt087Dza2+d6mpaTYTacALG0oTgh/k5NUYl5eo/6x9zuwPxcvr5twpx3oz
	 o39/wu/NTJo8slYtSqJI7WQaldXhYgQV86x+LZIgCAgCsddpq+HDqd/CidxVQwzBjN
	 JI8rnthiDC9cObvsUwgpXnj4Z7oW36vaEeQwnSuMv5SqqiCVPnl1vuJplgI3F87KZj
	 15GjoMl7aCGgw==
Date: Tue, 28 Jul 2026 22:25:14 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 05/13] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <amitGGcHyVXBdpOI@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77A68C0003
X-Stat-Signature: agmdua5bmu6kuw5xnihxwz4qszpc95h3
X-Rspam-User: 
X-HE-Tag: 1785245117-240966
X-HE-Meta: U2FsdGVkX18i2LpZDGDt2f+0+ekejDJMNeTupGwp+eAskq0xi99FFL9MnFBMlxDC5rGy02Xw5/uUJHFCq5D8mFlqNBKMP+cA3bHPcPraCvpc8YyDl0oxzq5KMvwm9hjFASuiYVeDVi6xquv9PDd3VBCe42bQECy1B84gzwUtP67Z9xQiTbL7tgEqU18MEskddjsscdyKQRlbcuveO31kjSqEvCAFl+9bexC34q7V8wPUBvTPQ1drDm/uSt6e50sKOSr436V6pJ/ttfAiMPQ7hB3ezgCb7atpUPBimIQf/CrTKgptklDovfDXlbECXmWh9G3+RgGtIxL5/g5O1Aalz0mFtAwN+WlBbZw3TMfAFUGVknedktDXQr/sRsOrrf0h/fyIgsvPLTPssZD0bz26MNMf8yLAlFdUaWV2d61UuM1RgvYblOSpa0Kwnb5BGT+WhyuRKe5qTlkEyDvewbzkCfrW5JF8GjjF+dTDbC0cZr+c3jSM2jDqSGG6/P+78wZqS9mNDjd0Vnr1fHLYaK2UkAokxhmYKvtJS1zMcOoYzhqW2l79veEbApuPg8AALUCq4E3wlGj95YCQJlMyqPJrfgV7U1B9njvuCGdM1q0blMyjQ9PcDhDhoQ9CiDUDFuzwYGhXRHJELDN14YzTV0+Kl086FmyIqcUA6FgBEDL/N4AECpxqJOmht8SSAQXJpTTQX+RFXvpjYAWfen1sVlcamcJQZXwOqG8EMs83byKME8RCdcevg6uT6FOXTMr9F+1A2EKXfTn8qeb8tUzMfxY1qwR4TCjA5q4s9KYTY6RpLlZULpLjqFU/xnomBcwZKobVPT+Y/vMPAMuz7gV92Dfe784SCSPKdIypjUqdqU7EHSGLvNgCc0puPTbZq+XcdNKV3gTeFHgJd8wzF0HOE5r1cRUeCia7v8lNyEIa2t+4xuX2Gc2+jkpnqyjItBoWz2uvgcKPLuGZOrYVVzMhP14
 WJ4/gVOC
 1sK63OxBjlVkgIxCUFrKrT4BR9A1GkWYV/OKktQ8HHd6mfWbmt6n2X5LAf8UA4QQ7pJv6hjlPA89FYaTiA18g/qusKw6xsSnYscclAICBl+OUw11Ud+z/mH0vtPM/Z2RWXlAnNDSmzQK9NSZeH0wwWkU2mTJ8Xmatq8ALipRSrgYKIgrhqkcxyqqMnWkjMxLuR7GzinHuvcoYF+vNVoUOpe+aaEQ/2BBGiut71GsG6z2AUubPstR1lLSrM0hb9qPy+cCgknXuvvSxQry3yM4A4Y66tfTBmvIB9cVdfZFB2G5wmp4wDw6j8EM10YGO9tBfbLQ0LYB56DdwEVEAmTNKKPAPiUcIza2OvEG+l8hTIrxjK6Au/h4fS3N4PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20260728132514.EQFEIa_TmuURcDcjuFzEEUVrRjWxrNyE1TUZyIWSV4A@z>

On Mon, Jul 27, 2026 at 02:53:59PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract getting and
> setting the objcg field with slab_obj_ext_objcg() and
> slab_obj_ext_set_objcg().
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> No functional change intended.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

