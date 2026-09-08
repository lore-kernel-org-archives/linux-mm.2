Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AB9C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7516B008A; Tue,  8 Sep 2026 02:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980D36B008C; Tue,  8 Sep 2026 02:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848A76B0092; Tue,  8 Sep 2026 02:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6186B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:24:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFF30A4490
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:24:32 +0000 (UTC)
X-FDA: 85189605984.03.30631FC
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0944720003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:24:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=wyuan.org header.s=key1 header.b="oo2/bx5o";
	spf=pass (imf03.hostedemail.com: domain of wy@wyuan.org designates 91.218.175.202 as permitted sender) smtp.mailfrom=wy@wyuan.org;
	dmarc=pass (policy=quarantine) header.from=wyuan.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788848671;
	b=Ns5pAp7ckD+yHc+ZJryNLpIHBuwAj7tnSW+8fq0tVPq3DTXo61H4a04ywppRTdT+baLxHi
	6kW9LfesCn6o9cj833ul/UjNgYB/jF1NUpMbWXQhGixUqX1m60D5RuoHPQI0nz3Bj0ERwm
	bGdHKq2pba2u5AsPiDrO4ooWoErwJ3A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=wyuan.org header.s=key1 header.b="oo2/bx5o";
	spf=pass (imf03.hostedemail.com: domain of wy@wyuan.org designates 91.218.175.202 as permitted sender) smtp.mailfrom=wy@wyuan.org;
	dmarc=pass (policy=quarantine) header.from=wyuan.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788848671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFbTtNDDJiHEUy6K1Uq+nqBH162kK/fgAwxE6wjxX24=;
	b=ZK/400Cvj+IWc2OWlOD1E00bfR1nz5tzalmaw7XSNs1p2E+rm2Lhl9sai0JV9Y2UlcMeYX
	AxBLLRTPaY7rycJ1ec0RAvJhtFak5eNimexshKMGQx6XBpN2nh6844CdAegywmZiUaEMYc
	Qo4A0+LNNB1facY9MrZQWKeGGb0/m7A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MBn0CE7Kymrqbq8YOgG9n11MvQW9GyGybawOGCVLhd0=;
 c=simple/simple; d=wyuan.org;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788848669; v=1; x=1789453469;
 b=oo2/bx5oy1TuGPea6IYvFjuewfguuRCCJm5w1kFDgemAn+fd3O8eUODhW9G5CLUafkxTgsmf
 jeI+s3AEkIly0uWxYwJFuaSLyeUAzjySJqN11OIe63fRXvlaPoE6thtXkZpR0Am7VYGttLIa82P
 rwcf8RD0q3fKMjm76tsDNF7L25iP0uMXc2ed2ury8GGgzQCJSaHypo98O1TMzIFKAAPa5uRQZ3E
 /sTVxef8G/OfHPPznGsxtV4W++mq7TxTx9CGLg3zkKD6UbIaVZk+hOxy85ZaiEiOfilKvqENyap
 9HpZlCcWvFlMePbi0TSFAFP4mGFI0ZuonDWIRldx2ASAw==
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e408994e9e537c8c;
	Tue, 08 Sep 2026 06:24:29 +0000
X-Mizu-Trace-ID: e408994e9e537c8c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 14:24:13 +0800
From: Weijie Yuan <wy@wyuan.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
Message-ID: <ap-qDThi-NQgVXVD@wyuan.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
 <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
X-Rspam-User: 
X-Stat-Signature: 9keiy3ygiokrjfqf9m6onfnqurihqmo7
X-Rspamd-Queue-Id: 0944720003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788848670-27500
X-HE-Meta: U2FsdGVkX18GM4dMMJRFbyr3zlV2XTGtipCQTHGaI4GGJlHKG1Jp39s5NiQx04eoVR1SUltWnIeisrdUzC9bWCrQi0dx68WYxJSdwjFW1cUrQwccVk1h3YVM+811+1Hcec5m4QQD+g7NSHN4cfoXcHfY9ufkUl+eNGPHxMnVLqe5XyWxUq14hPgp/8yRCm9j2mW9hf48w2VzxBnkq4bJOmW5BxKqHwMrayePJfSlH2HR494YITM328rX26A4de7t16+7ffwzkFfpQOw8Ax38quZPC6AwuyQ2Y1Lo+obQkgS18PNmrnBiJYdtC+//Avm+ikzrIUpJxoQO5USfXNv8yREaU3vkdhbp0WjI0ZWuX7pAo4uDe/+DwReI/Rwr7gJfRc6ZaIHcKD8YCE82Y+FAq8p8kUYIAoD7kW/tFF/rCf9p2Iu9t2o3wmDVpzuMF6iybPyX1Ng+NcpGB5Z6kyXFyZnziKw25f8cOccvWMnl1BNab8RuJdgE5FhepiHZ3QFNuwUTXAB6q+unCeliTnKr345gaa+aHP9WeEoIQeOCsHWE6fdzuC6LBJukS0M7zQ9N2C7uhK39XVZAff9OjEVn8i6Eax0JOCF7aCkO7n86yozKKxVnKagwFU+bXznUTZrthvS/3yKX3gH9LwgObmv+W4H9cnZrDSVxtC7ldHhfMbmURsYsN4SG0Hg93nBD4SPZ3Be5oN1OjHLiZ9RzBOUfnJYj4gPPq3kULeu8dWbw2jiD7H+F1x/FjjhUSGAp5Zi3nszgdyjT8v/F5gie/sMmSlJnAkMeTcUi7GWSOvjyCn5jX7wXrQgIWuEkZzovA7MLWWaNKMiDMzxF2DAfE+ILl9/qZgrtNRSPcMRSMCziatRR3KSq7HVndm+nXmapZpUERcTDruZEV/DkXCmyDVzxjP/dmneWHswBoNujEsLD/SOq9whX0BDmQ437pSetmveAqENQFE6tMD+DjrZCg0n
 JJ72Ky27
 /LQaDR6AtHW1PDhgo63pxfYUPWQ0HtFQN+2VSei2gs8nwyDprZkS4STnVo68+oF+PpE1jbTmCnl2U71Q3SIWTF4NXaABGtHtEkofvzd+Ou1D49NTYJPM0rF0UbYS3HQ3maYx+p/Pj+WBHfHJsRMB0FYLsCgI+CPCQWxky/8saPy51mZdfoeVU9wd4oH8FUwYu5jVMEvigF2NcoUgn+EJcoNMgLhqxFNPfDyP9NVrVMyj9Nrpsne8MFsc0/zK14pwdI2S7gN26HBiH6ctCX/J81bLlzko0lAZvzFZx3e3UiFRMvezuIXYDUnwa1fj2JBUK2nZc1czWMqESvBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From an outsider..

On Tue, Sep 08, 2026 at 10:41:23AM +0800, zhen.ni wrote:
> > 
> > Sorry but your whole reply reads like a LLM slop. It took a lot of
> > mental effor to actually try and engage with it.
> > 
> 
> This reply was written by me, and its viewpoints are not simply copied
> directly from an LLM. The LLM only assists with the wording.

So that's probably the reason. Your previous replies was indeed very
much like the output of an LLM. Even if the idea is your own, after
being "polished" by LLM, it's hard to read. I know English is not our
first language, and it's not that easy to speak like a native speaker.
But may I ask you did you read it before sending them out? I really
found this bunch of overly formal content a little painful to read.

So I suspect the LLM may have taken too much liberty in polishing your
text, to the point that your replies no longer read like something a
person would naturally write.

The "Summary and Plan" in your reply in v1, both in its formatting and
wording, looks quite similar to LLM-generated text to me. So I can
understand why Lorenzo asked whether you had used an LLM. Come on, we
all know what LLM writing looks like.

That said, I do not know exactly how you used the LLM on your original
text, so please forgive me if I have this wrong.

Thanks.

