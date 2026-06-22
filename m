Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9877DCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213E56B0005; Mon, 22 Jun 2026 10:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4946B008A; Mon, 22 Jun 2026 10:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B33D6B008C; Mon, 22 Jun 2026 10:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0626B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:57:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 638181401CC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:57:07 +0000 (UTC)
X-FDA: 84907851294.15.1827994
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A23414000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:57:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=bb2FxCcg;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of xiaowu.417@qq.com designates 43.163.128.47 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782140225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGU6np4obOJiJQaY07OnznTkGUZ3Y1DTcJV4GO2zAMk=;
	b=7J2gd05Vzn5Jdgur7BqfYp5sNhqZTi03o46o/eQhw+Rca5RJY09kQGmmC6Qgk39lca7Lbs
	rD0x6G+nOeVLem7WOIADzOe0P7cFW7PD3pN2B48bJqEPL6wpzeZvToff4eCdmRWk6lEkUQ
	8HWYogRQJX5w8Lb3kkdJKd9ZaAzi4jI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=bb2FxCcg;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of xiaowu.417@qq.com designates 43.163.128.47 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782140225;
	b=Q+tXJ6PukxCkkEV5v0TfUYJYhLUObuZadqHoPF/JU62ET0+JlFqfGCODYEBGmFBEQeo0b4
	umjF/XtNuTz21AXzQDnb5miodAOIlSKDotGxyA2n4QJAiFlDiLdet7/vpc8S560dXIPMf4
	O96Td25eTacriQii4fgoEXDcpUWiRn4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782140220; bh=CGU6np4obOJiJQaY07OnznTkGUZ3Y1DTcJV4GO2zAMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bb2FxCcgDgOebEcjlj4dq2Jf1DJ+VR3VNCMIrnZPGAFNlMTDDkLGNBj1qlTl6CLwe
	 Giorm7LAHGXf2sM9iNctgy5ZvmXxiRyJx4nkprHOg3aSgdSSeSfVPoetTMYD0gHw5e
	 HQNl7J61T/bm3Vaixiqi3Koyrpwq/cQwL37CLvW8=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-XMAILINFO: OKOirRU4nj6hL/Cx4EiS/nyJjhfozdbVDml+cV3gyTZ/RghjWx652Gmqqy4ULZ
	 48y3VDdpE58CAeQNu4fQOpnTejNbkWv2RwOBoLUiedS5AnUfUZwY4bzy3fvTiwxTKRqUR6zc0UY5w
	 zEgtxCdJq21kdyVO7R5dSJLlugmDjiA6vkkAqFGcc/dojoBleZf0WYYsl+jHv9RUsWF8/4RZe5yCG
	 HzB6iDdsRRPCbgZxvzNVq+//Rnj2ttwbssJZxpZP6KamrVj1SS+5sBWGVbt7Q3lBCCjTbcyn1NhsD
	 jIWiGsVi43VbuueczGeQoYenZKAJNKsLQGWuGzyH9cajxeIvRpj+XDHzY/Y/Xxr2pVUekNlNqS57g
	 UTEICULC3XqCVv2s66kTRSxQmlwebhUg3JIxpGwX3rCOS4aNre4L79TO+HeuNbjiBF4ZgdKJI2Nvh
	 f/jlN2wyOtiPza40iUD+YfXdNtCIj2VRT2AC7a6XjmDhIq04ohkb91W3syqR307rgnjbG42oWLEZx
	 hCRqjMA41yaF0U4IIX5mZtdSOYZwlhUVyBh6/1eLiAnjtZ+D3pOwY+uspCZ5+HH8i7N8FquDSFCG9
	 vNcEzUy1OWZXhOj11p3XBQVjg54v4bf/4Ne16vn5OgcaPhqlg97uI/94t/EsAMAAY9tZp+S3xGju9
	 SfSwVHckP3mc0+hstJf4myMqi7CwvV7X1fWXnkkToYTqUZWiQGfbtlSbCFbSqcW9W1WxHEH5dYfFo
	 8x6otELUAkDsQTTB7TJU2Vdl5lC4o0OU2Y7WtZQL5xZpt4mvMcXedOss1ADOXydE7pK1Ehl4FawCP
	 X1luAQdIBxbRNCWtVXFxL7qmVbkb37jBNqHYZ1uklgYC0MtMV8pgvXzTNKjVLBEEpgmK1WNaQJEtI
	 RIyybKBtJlkhIQJN/308mq78gVLtFrP4W8U7Wx0whAmxI7wckhfeAC2kD8ACcDOIRWToTnzwYr8qr
	 mYXly0f7xHmOqfS1nZEuXbMbyWZxVzdrOj0Wlm4PVua6Y+QzjfnxEe5kJOK0x17yAB9arlqGaNRBe
	 ABDve+MGh3TCuwFFQzBEmpgLiPfI+C5AeecP6T2fmohcAycp05GW2xGBqHcpMhWSoJcDPoKdfxlvI
	 1+TOFujjXMk3vXq3evNy6Fh/KcC3juqI/3q1aB7eF774oA==
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id E363CE35; Mon, 22 Jun 2026 22:56:54 +0800
X-QQ-mid: xmsmtpt1782140214tw1rxxvxs
Message-ID: <tencent_12A1049445F2CE248F20CB235AC111353A0A@qq.com>
X-OQ-MSGID: <d35872f1-c62e-421d-92fc-7ec1c3d32652@qq.com>
Date: Mon, 22 Jun 2026 22:56:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
To: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
 <tencent_45CAE878B5922990DB102BE05A1BAD50DA09@qq.com>
 <e54ce8be-9480-4583-9c6a-d0dbe1378f53@kernel.org>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <e54ce8be-9480-4583-9c6a-d0dbe1378f53@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gf3wd9u47zpt8mi8xnisp386moxarmfx
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A23414000F
X-Rspam-User: 
X-HE-Tag: 1782140224-735906
X-HE-Meta: U2FsdGVkX1/vomzoTk6nslDzSyHSYNPCQWui5H60FSJHhUUWDSwJI4W9yncfKNmPr5vDpShHRrIiLxqgLp9yenxibO9MFQPHDR/YRcYD/o7ILEZv+yJSqICFJJWhlz09hVqPp37IRkt7V2kIOutzc0esHOkVFlP+dV/qrHAdB2zEYwxDAXn6U/NEy/NbpO+FG6lHIVhKEi5xRvA8j6G8VXP3mcJfdqphPowzTbOyJJAcENAAJSqprvyLaaVxg5FxkQeNVfxm22sTmlE/Y3QgJbm6jB2e/BqdbowNCENIa8bOW9UA8mjGhoRXeQNss3qgMCdOmOU9JFQ2TuuSlD5JGO4IXTADGEZDn1skB1TrdaLkqkudlC9RPsNwyemLX7kQQi75UNPu366u5mzQ6dPu/DA4hb/M4Lw9/8I7ejy96u0Q74TVdP0qLChp2cobKONJAPkqQAK/ZE666w46UaWKFUVJSMEeuWeSObKzspQpIomQpXo0CEwl8y9TkePmA3oI9c69WDANtjC4RCsrU420xhYqH/5dGia/eGCPgFu+Mthis8vprm417ZRDrMSY6MKiWIYWmhuJTsHLiXtFMH22CccxdoP0HrCr3ylUycxpukN6qRFkBN/rHJSm/S4vG50hBZB0K3ZHKZ7ZB2L+aIk53dMOKkzsJ+0Kec2BjI6KraXlTvDiww0WDky18QyOwksaXnEU1EiL0sA3GPYR5ensTfD3iaOJsJULY43cxxCttzd9pdblsuvBwnXYHrPadaxC/IHnq9/ffwtwGAFCGJT8EpSTpYqgRTDvj535G7tf1Tr+CwLQHG8YIdsjNWt4El73OIr1oAQUd3ivT/5Mw0oozZ6lAkx+gQPY1iCZD5DxliQ4Kkmau7ojrhBxq3WQlJjlPGG/2je6zoHSte+8IuM75p9mWIH4l5VGEqihwVJdTRw9WOF7lb6/VIBSrcNNtp8FtLmhjIabCGR8r+p1eO6
 zMdEshLj
 7yrrstpXu6SlqqLV/l+XKG6aRXvn8o3PH0XYJzF4SNr4gX5xESbmAxLmQZp70rHbz4oHwvfoaOJaFx0kGDgTmlZ2xkDTz1JDWqo2njqKLniAaRG27lSZQ3XZhv26NoSbgiSOLWD0WGneBWvptMDHSbedHVppIIEmqbv/BlYqLIqJLPleG0huSJ0n52t3L7npna4p9haUTIZZ5BebzRgA1I7NnCNu46dRiEZVT72+SlHVDFF81UOjhE1IE9tpGwu0x3Dv5jkt4oAr/GNJB6apRdrFdk5czwCXpTUf4pAtkHCe8FP+NugtQAcN4Vzhsghuo9yc6wkIaxTCi2/ywUlMxYpve121vux9ouu/EIUthRemevVRykUC53LkBCM8LJCwTWgQvd2PrHGpA4nLFfEPBL1s+hpHhlh8UYI1q7pjwJrbGdlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Mon, Jun 22, 2026 at 02:28:44PM +0900, Harry Yoo wrote:
 > On 6/21/26 9:29 AM, XIAO WU wrote:
 > > I was able to reproduce this in QEMU with KASAN.  The trigger is as
 > > simple as passing a large (>8KB) kmalloc buffer to the new function.
 >
 > Thanks for taking a look, but this was intentional.
 >
 > I should have documented that only kmalloc_nolock() ->
 > kfree_rcu_nolock() is allowed and kmalloc() -> kfree_rcu_nolock()
 > is not allowed (yet).
 >
 > Since kmalloc_nolock() does not support large kmalloc, the warning
 > is not supposed to trigger. That is why I added only debug warnings.

Thank you very much for taking the time to explain — I really
appreciate it, especially since I'm still learning my way around the
mm/ subsystem.  You are absolutely right that kmalloc_nolock() returns
NULL for sizes above KMALLOC_MAX_CACHE_SIZE, so a proper caller using
the kmalloc_nolock() → kfree_rcu_nolock() pairing would never hit this.

I did notice one small thing that I wanted to gently bring up, though.
Please forgive me if I'm missing something obvious here.

When I was reading through the surrounding code to understand the
pattern better, I noticed that kfree_nolock() — which has the same
"only for kmalloc_nolock()" constraint (documented in the comment at
mm/slub.c:6828-6835) — actually does check for a NULL slab:

   void kfree_nolock(const void *object)
   {
   	...
   	slab = virt_to_slab(object);
   	if (unlikely(!slab)) {
   		WARN_ONCE(1, "large_kmalloc is not supported by kfree_nolock()");
   		return;
   	}
   	s = slab->slab_cache;
   	...

So kfree_nolock() gracefully returns with a warning even though it too
expects only kmalloc_nolock() callers.  That pattern seemed really
sensible to me — it costs almost nothing and prevents a panic if
someone ever passes the wrong pointer (which they shouldn't, but as you
mentioned, the constraint isn't documented on kfree_call_rcu_nolock()
yet).

I also wondered about the difference between WARN_ONCE (used in
kfree_nolock) and VM_WARN_ON_ONCE (used in kfree_call_rcu_nolock).  If
I understand correctly, VM_WARN_ON_ONCE compiles away entirely on
production kernels without CONFIG_DEBUG_VM, which would make the
subsequent NULL dereference completely silent — no warning, just a
panic.  That seems a bit scary for something that's exported to
modules via EXPORT_SYMBOL_GPL.

And since you mentioned that kmalloc() → kfree_rcu_nolock() support is
planned for the future (the "yet") — wouldn't this code path need the
NULL check at that point anyway?

I was thinking something like this would make the function consistent
with kfree_nolock() and also make it forward-compatible with the
planned kmalloc() support:

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1266,10 +1266,16 @@ void kfree_call_rcu_nolock(struct rcu_head 
*head, void *ptr)
  {
  	struct slab *slab;
  	struct kmem_cache *s;

-	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
-
  	slab = virt_to_slab(ptr);
+	/*
+	 * kmalloc_nolock() never produces large-kmalloc or vmalloc
+	 * addresses, but be defensive: fall back to defer_kfree_rcu()
+	 * for unsupported pointer types, consistent with kfree_nolock().
+	 */
+	if (unlikely(!slab))
+		goto fallback;
+
  	s = slab->slab_cache;

  	if (__kfree_rcu_sheaf(s, ptr, /* allow_spin = */ false))
  		return;

+fallback:
  	defer_kfree_rcu(head);
  }

Of course, this is just a suggestion — you know this code far better
than I do.  If you feel the current code is fine as-is with proper
documentation, I completely understand and won't press the point
further.

Either way, thank you again for the explanation, and for working on
this series — having kfree_rcu_nolock() available for BPF and other
contexts will be really valuable.

Thanks,
XIAO


