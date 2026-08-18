Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89869C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3416B089E; Tue, 18 Aug 2026 04:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874736B08A4; Tue, 18 Aug 2026 04:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763646B08A8; Tue, 18 Aug 2026 04:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 561E66B089E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:21:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2E62160ADD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:21:56 +0000 (UTC)
X-FDA: 85113697032.20.ED8E5C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E7DC1C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:21:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cv/zZt18";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787041315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aLY/2rHSc0H4xWV38Nj7mu6p4voUj76rve8wfVW5R4=;
	b=epXTS12jKfg3NQTLuv4ZzMzV95JF7vEPaidTPtoC8iM+z8dZ0YCkY9A4N7Lt86lK0ngXEe
	XRMvMRiEh4/v8XxaDHmbuqJvO+A0vrmZuXb8m6p/RikbBlpIu5RP9lh99eDV7fzthQ5Kif
	Sj/L9g2a2iqiiouE1/OMt5IR+ffi/Po=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cv/zZt18";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787041315;
	b=ae3KXzqIRgPYIi/FPuCY015g6b8+USk6DixH4CF5sDWIJK/jOtzonsSPjOGIJ97maal5RK
	5AcIo1i9oXtBv7OfSsPPm4TnCv8jBtHmbyfeKnzn+5QVJcQQgsysDCMFI39rvXaQ39hu/F
	Xp3tNRVzw4++6gf7DSbQEFX1QUR8SrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5705A601DE;
	Tue, 18 Aug 2026 08:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B117F1F000E9;
	Tue, 18 Aug 2026 08:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787041314;
	bh=7aLY/2rHSc0H4xWV38Nj7mu6p4voUj76rve8wfVW5R4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cv/zZt18oNDbdfW10lQ4W9vSXzpH5nZ1k4+9zsUHQ3CqiEXxZ06dotCXkyHQhy/CV
	 Sq2IftAjlNy8UvUPBoJHUnHOIshmc8hILs2/Be9sOMqM1batzY7Zwn3HlQxq39zjsI
	 aL61FcaJlbu+K8D2RhMZUaOK0SeL7EsiUbuQ/cWPRTDJjnYt7GAzEOb/NrDDKKpkSx
	 BhIh1nJBpOd7fAcdjypwpS0jWL1M1r42CGIb8CpaLYgiKa/GJbGdAk2mVuZvRAq/SV
	 5nd3d+raMBd1OfXPvNSR0hiwqkhnsGzlWO93BQQbVmrB28Ktw83ZCTYTsoU5iJw8/M
	 I1HMJSfnFSevg==
Message-ID: <ffa0c74d-415a-4a63-9843-7b9412359c46@kernel.org>
Date: Tue, 18 Aug 2026 10:21:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
References: <20260817080616.52946-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817080616.52946-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yzjcftpn6d5cakngesqs3fudwfwtfnu5
X-Rspamd-Queue-Id: 3E7DC1C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787041315-606588
X-HE-Meta: U2FsdGVkX1+Jxf3XaGTkP1imzN/cOz1Us9zLsi9KSsXlFqJFyFIyHoKB7e751qzLUIhcJ592X7UmperAZrzCoS09AaPt55f87BPmRvmYK/Xh/bOBy69swT6rli+hQENJbf6bzgA2jIpd/OEeu5XyHsmVGJ/gio9KtOHMhf6Yn5R13dOOVNhK1pK0H58dOFs8Ln5avSDlhSlNYOn2YqFinEYP5dWs11iTcC5egp65C1hHkZ0PWCcCU+AHJ2bl876nKnm9C2+j6lY/wgOjVLpxcD/1TYBxgOcdPcAxyi2i1GwKeqx7NEaePoYiM6t6xH1wdvsuXUAPuouPev9DcZH8nxRt8XH88s3q9JWK71Omf4NXZi0ZSr6I46IUcAJpM+N7OJIcAkdAKC13U1Q7GZRjVP/Evalzte01SlrYcOn0KUC7h+cq2LnRNDYiIUL3R7iIJrnqaVb7pce/pj1lvNEWaEs17zHZ0nsU10+q5m7dSdOGl612mQmFkuTr8PE83998IzSI6Q6e6KlRcyY5Ya6ZPO8WUUxLolT48bGCqqbcrYJDzZS1e/YxT4XND6QwPkTKCcuBUMMLfvw9GDyLYnD5mDbWZsZnaHwAzo+385NR+AKd1eaHS16QtzjkuubWNDoDSdd2+qLOeJUQ3yO2nvcOde4deQhtcNUBYeTYPyyOnZq7tkia910yQxyyh2InH+o9+ZYxTOYRrFQhBokaI0NKnghd3Bu0o/KKpMSRNqk3RwOSdV8m+Ii1FlhzeD7Ybr9g8iz5qhHeWQnG39nIJMKXMwUhHlDN9pdHZeXIu7Puqcf5lfxt6gl1VxH7gxwJ2dKWbRrf97evicWxdrmkpvHt3YCmlwAsxvndCBz3zVbQrEp+Nc/mlQfRjBsVV8MTxhCCN5wJTyhyoii0A7TNmht9llotpqKDZJZFsxlsYe/sQYzqc7xZeTTJUxaI/B/XCrz9UdEkWibJMKGYp/ZstbK
 3f32pCow
 /7RZGQMdJOVa+Vih4EtLdh6+SLcUzi2sK394V4tZXp9ry58AyLua+aVfmxfUYc8qAG9M3PC5tkhD3Zk5Gm6Ge95IgyDT/Ptn4j8sYY+3QiOhc95c/w3cvBCpcPwnIYvos2utvCVxhoAhhyEaOmNunBrHVDPuQJOPYhMWK8ZjsVhiPi/8jRXG8ViXsoFi3ruwTjrI5x4MHITvrXnFwvkCSoA54NhXshEYOwrN/JldAkKW+eeYaRVOenGU16tTqna1zKtrYzB4AwQVnlFqv4O6+bZzTO6Th5x6YNLskdKX2v7lG0HyTldep7x91k3lwG5uRmGEH45mBcGwFmsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 10:06, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Remove duplicate open() for local pagemap_fd in mprotect_tests() that
> shadows the global pagemap_fd already opened in main(). The local fd
> is never used in the function.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

