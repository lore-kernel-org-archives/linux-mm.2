Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300C6CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB75F6B00D5; Thu, 25 Jun 2026 15:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90A06B00D6; Thu, 25 Jun 2026 15:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA79A6B00D7; Thu, 25 Jun 2026 15:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EDD86B00D5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:20:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12B3A8C828
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:20:35 +0000 (UTC)
X-FDA: 84919401630.14.D26D4FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2F3EB40010
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:20:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="je/Vy0CI";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782415233;
	b=L6v0m4zkLWAd9BW808VAZSMNnNDWQAG+pgEgPb31yi4ndGoYzIJA9bt/9WMEyTSNWoaVQq
	kA36RjkYHRF31jjusAGVmTLGs/oJx4Wyj/04oN0X7WlrmFiXsSXck8KSynq7VGiG3WkYp2
	fEM2jY2heOMje78GPy7zoq2nfTY81bs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782415233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeIALQ9lVn1SIsM1liZMf7kfmaSTEnAC37rRwjunoxA=;
	b=0Vk6JkDjIoHrU7hsYLfbdgHYvGsUw5DrUI3MI5Gnc3IGW+iVWXC5NtHRjSo+vi1UZafQ3T
	yHw1tH5OXaoFSjFI7ZzD1QT8PJIRmK/kww78IqZd/qmA0Uuy/vOWr9Y98PShxTq7MZMAs7
	iLlTuS+AHIVs++XTGe5qxJHglKiK2Zg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="je/Vy0CI";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2A4142A89;
	Thu, 25 Jun 2026 19:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9621F00A3A;
	Thu, 25 Jun 2026 19:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782415231;
	bh=SeIALQ9lVn1SIsM1liZMf7kfmaSTEnAC37rRwjunoxA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=je/Vy0CIHpoD1UZ+Zs15gC66MSj4pUuNtNzTrgiqpkSQLVYaQg4ptaEIrGpH0GSui
	 pw/S20iVb3w/jeBInkGF+H0ZTH8jloS0jGhuuGzf7iEz0RXefIYJG+r3SMJ5SWp5SL
	 Cra8MQIWcrQDtGDJarVb7d04LHtNjR7FAyU34wA0=
Date: Thu, 25 Jun 2026 12:20:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "Zhen Ni" <zhen.ni@easystack.cn>, <vbabka@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
Message-Id: <20260625122030.c036caf02435810b5ba0e291@linux-foundation.org>
In-Reply-To: <DJICBQ0OIM2I.3VWL2AQBX12F5@nvidia.com>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
	<20260625043101.338794-2-zhen.ni@easystack.cn>
	<DJICBQ0OIM2I.3VWL2AQBX12F5@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F3EB40010
X-Stat-Signature: e1k3hte6qe9kqy8mz4j47351pcz6fw7i
X-HE-Tag: 1782415233-264814
X-HE-Meta: U2FsdGVkX1/fEGp6ht0R+f5M3cm4x/Y4ef5YJNcW8u2ksZwiiIPcPLGdt1gBL196odu3Ads/Kh251dvucIg4A7MqrloV9kFTzOwmh1bolCbq6TL93SZhfVjrTHrL2oTpkEiQNUeEKMei+PMdort0i5fRprd4pYgdHVbURd1OVItv9qWGqNB1OJv39+QMqEbjVonL70+BowJG6kNJMjT4kMWiznu7nlfx4Fif4Qe29zoePK0TnTgMCCTTUPZZlBVVf6H5tfLt+AjYJP/mQ6xgnOHWScSs57Hy/QnAK6mgtH85vOU4IXMtFVzST40zzoNGbqXs6MlX/6ZBGoWSYY54y5ek74AS7gwInmYlEqSTT04XG0QgfEj9TxaPLpvuCQ5fDeagGALfnHIOQUeSD9swqJpFjiBLSUhnI0c0M6c3W8aN7KaYRGzaQxsRE86abltGe57XSZ1Vj3I3VoAgO/TRBfNaQslZXmTlZ4I87zf4aL+/vRk/NUc5o5gYLr4TkFwb4UpdiL0BDGzwm+78+lsJK6G4WyoItYp8q20CxdLUD1dcTPZJGOlNwD+sYP1vowlp1nRcgdPjMInOMfTVtTHwr0iDfDwTcA7evuC+zMlnal3T3fhf4MtqJZGcfSTNF2NJyJTJ6CH2JhOMqAxkq2+E0+sUhja+HNz0CBXxRhT+WtUv/mLpepQQHGhFouHTG4BtKIGxtgwo7PAzs3hRt6e7pqzsVgJFCigmxLgNSXhvI0hZ+PdtHI5CbTNqIriUBHluXyC7+k+t3/Ytz5FwALZ8eYjebNYAGhPJMtmfR8+kEEkn3wi9CQJiRY+/ezFPIi/pPONVCxDa+//CwO1BnoilAFvgUGgDTlhvfEaCsvX6n6ID4dOEo841E7IiJuE8z0EziPPwLncdutU1bFDpayK+ckaF+2WEEm448vG6b1LxBsHmrGQsgj4/LAxBL5hR4hC0sfWEnX1RpAz4qcCH8k8
 2AhyzBQ1
 LhflXRY/6vn1Kk8zBN45jltS2YJTY0OZsiNTMuVD3d+dTYk/TucmqETfPyZdGEIYteEb4+axwcZboCXYW38aquUbkxtPh25gc/MJXmbLpJuZ/kcAFzcnDgJl2PoGqIv2wSxUrOK1EalSKG5Z95zuW+53ZrLtDZ8T7K7Bpv4qkoCUIaFTMF8qyIAhWi2H2b/Cp8nd+E+/ezfCSZZ2xAUHMJQ8rWyNvBz55ZXOuNOXNxWLBs1k4Vv9fEux88HzyfbbNGNEse/7m6HfT8Wi1P48C5vi9LcwkFFvfPhn/tmFwEV/irHaJSWHAknZMRJmPbP+ke9k9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 14:26:51 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> > +static ssize_t page_owner_write(struct file *file,
> > +				 const char __user *buf,
> > +				 size_t count, loff_t *ppos)
> > +{
> > +	char *kbuf;
> > +	char *orig;
> > +	char *token;
> > +	int ret;
> > +	size_t max_input_len;
> 
> This can be const size_t max_input_len = 32 with the comment above it.

I don't think that local adds any value, really.  How about

--- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter-fix
+++ a/mm/page_owner.c
@@ -933,7 +933,6 @@ static ssize_t page_owner_write(struct f
 	char *orig;
 	char *token;
 	int ret;
-	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
 	unsigned long flags;
@@ -942,9 +941,7 @@ static ssize_t page_owner_write(struct f
 	 * Maximum input length for filter commands:
 	 * 32: print_mode command max length is 17 ("mode=stack_handle").
 	 */
-	max_input_len = 32;
-
-	if (count > max_input_len)
+	if (count > 32)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
_


