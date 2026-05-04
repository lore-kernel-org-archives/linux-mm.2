Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1C1FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6906B0005; Mon,  4 May 2026 08:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7776B6B008C; Mon,  4 May 2026 08:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666A86B0092; Mon,  4 May 2026 08:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51EFC6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:59:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E53D81C018A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:59:01 +0000 (UTC)
X-FDA: 84729742482.17.AE062E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F8FD4000B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:58:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+pnsy4f;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rd+k3jiDvPrta9HqIiGVaCUrnheJLxVOfkWrDhyJjA=;
	b=k5Iie+BHzdtADwNapIhHDOYi2TmMppwmuh55/zzCPjtRjBRyMrgS6/awfWA41Jik1aUQd6
	EF16DkfT4mIXQTzuTU1ca90KdYuEaxVRTADndt8GT4/aCA+Y4OWXo+Z7aAI+GFlcqg8E6/
	NqMAT01o0bVF58iGkam6EsEIN4ejAqQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+pnsy4f;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777899540; a=rsa-sha256;
	cv=none;
	b=NgtwKsxgDZDHKF2hNZeVq0I9o8DU3VRu3Z8tipolzNI5twqBakRlqwQ6h7XMB5RMADaC7C
	Or/tozIx5JKr64ZAcOFhNQJO3TLa6/cFWMoX1Jv4bU63GvzYVkyRJrEK5KSwcAIrstvbLu
	lhm9Bz+Ax/g6bvS95qvsnXsZniBRjyw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 223B642DAB;
	Mon,  4 May 2026 12:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179F1C2BCB8;
	Mon,  4 May 2026 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777899539;
	bh=dTNnqcGn0PR/T/HRUi9r3/g0/tDxUH4NaHjL6r0XTbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k+pnsy4fWPkXwfVMksDv+bMO+YyWftFmJ0jKoxspeeKx3X88cZjWmGCV5KY4k1Hf2
	 s/W/gJv9Am5Sp2k27ywUsBH/kLCQSar6mWpoWJocfSZRO/lPdlvCv8z5fVSi9R7Ww9
	 cWkmFEGgxC3IN3iT5gbpAxLnuK1wBjdX04WntgzGm2+5V4KK2OBklCc7yZJzxgIrIJ
	 muSGIOXoEeZJNpJLVIelzuqciPM0Gh/9y+F5kDE4wD6NAc1k/K4h0JMnglGjUqA+xq
	 qwxsorPjrCido/ndEjugddMooAR4PLQ0HqDQ1UJgG5GK4FYrKD/rNn6l3dz7Qqznb/
	 Vl1FDlafmDQzw==
Message-ID: <e33d2060-1636-4291-90d9-d715a622f462@kernel.org>
Date: Mon, 4 May 2026 14:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: ksm-functional-tests: fix partial write
 handling
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, shuah@kernel.org,
 akpm@linux-foundation.org
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20260504081638.683223-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260504081638.683223-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F8FD4000B
X-Stat-Signature: 69cbu5wb6dm6sh37cxjo5oc8bnnb7j3z
X-HE-Tag: 1777899539-442403
X-HE-Meta: U2FsdGVkX1+6c1GCzP8Bq26h6JLrcK4YOjAcjOUBrtZFbTcDOAS6TCkHLr/MLTXN/2CV2SeMo7hHYaaaP/n8xQy4UWeGg5k990Wr8kh8W6/8Qw5zzPhpBrTQliCq01pC5Mff9DJqTkK2NwoncATJYXz2bYi5vtAGC1lpUIS7HAtQw10MrVHIob0kffQcF2BypVgw94ZuMvlmnfYmhQctg/ycjet6pLXKhseAWDBU/l4VOGjP2gYI2dCfN6Z0vrJyGkAu6VhNP2uCu7iE6HTgWP2Xb8btX8L4CFpC2j70+WlpcgLXqVOp3mzXhjErD5G7NIFtah8LVhMgchDh7yOQmu1HjRqtI22xdQkU7JufHAUiYR6kg7sNNo7SPdGTubjHhGteVys6nKOohU+NYli+sY1AbwahBdBqzpVu9Ln+uY7nTbW4ruiLNHenBliPzIFS91Hu3R2M/1c3z0ipBly6QJ2ITxiqHzlulKrSmDSAPQ6bVn91/hK1aNDjgg0UhKImhgF8QIMJORj0n+9VzbMbYHfhw+VdahyrFTxoQrM37+1XSdWOnWXNP/UbiFIW2P6KVw4s70kLD3BRJfvx6mDsox/uyfJbOpEWgF6yR4MYgXdkR9qFxOWliB4R2Tb0EQuU/y3Hxz2rOJjrZFY6iOkcjp/qWlyXhBVC1URpYHmOwd3pW1K4qK2USQnBk7RBwPzvgs7yC57TQyviSFy+Z09kIP/i2FqKnDTJ2XfRRE7y33Pqz2fP7+DCPsC6kZ5jjcuboyhxKKQGw3qI9prJx350tsrGDmyM8EReODV0zBge4CxKLw/YLs0PyayTeq8dJxy9b6YjuJ+YCB6pue9qDZvh/SClcoiDceh72NrOBbF6Wgu63NaXT9o3uarxEc6VxuwtQpottLU14u7Z98cg2G2E/00OU+zgpFsJ987QlcAlPZr+fhISQP3OqBALJLuW7ritvW6skv/x29EyUUOUva5
 yL31GVTB
 nF7rxfJ//SPsaA9P/JIdcpXgF22Se3AthyFYmi3d/kyBLUywrqAs3IbOaOyZTIqXeKwukOtkqbV5BctF5PtJEU3XqXzuBYnHYtBFAfc0IXt3F8AWqxGHqF05Med//aVukgGWLrNKA1jbi2mzvPRXjrOJHtRn5bsWkRPYp0cazOf6oRz8G38xFBCwQ0cW6WYxdwipPXsMBl0Kg6smHjc8MnFxPx6QikFrRg4KcMzSCePpAxGauUU2WJNBsLmn9BTD3/Ts9L8rmCf3o9RGexrqNoMb3gVlM6FkjGBfYCPGybf1nM+jZI7uxMEjkq3aRWEPTnuBWEcwZiKeBN9ttDHnE67BHpKz3qVSUJrQfJTkkVdgncouvCZyp5x943Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/4/26 10:13, Vineet Agarwal wrote:
> Update write() checks to properly detect and handle partial writes.
> 
> Previously, the write() calls used <= 0 to detect failure. This
> condition is never true for partial writes (ret > 0 but ret < len),
> so partial writes were silently treated as success.
> 
> Fix this by verifying that write() returns the full expected length
> and treating any mismatch as failure.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> 

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

