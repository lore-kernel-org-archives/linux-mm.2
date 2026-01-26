Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757B4CF65CE
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EB36B0088; Mon, 26 Jan 2026 05:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCB76B0089; Mon, 26 Jan 2026 05:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894166B008A; Mon, 26 Jan 2026 05:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1296B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:12:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED6381B06A6
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:12:41 +0000 (UTC)
X-FDA: 84373700922.20.70E9723
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 71CBF40002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:12:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GF5Z8EMm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ERyOZJRo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GF5Z8EMm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ERyOZJRo;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769422359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1HyZXrYxupZ9VTkUvPpA6kmIimK4DCc2UwygBrH/rE=;
	b=vxNDgKoCjMXT1vOAXRVpqtr61qWk07o2YQ7qeWwBFqeC4pCrAQNaQvWecqyQBUahGO11ru
	GGBrOlGtso1/KYW7sRAJFDwOZwX8ExWFUJJ9ku+pCR7KBJ9Px+i5uThEtZdpj+OsLeFC3V
	uKX2FcVeGRzPGCcOQIFj297sCdS14kc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GF5Z8EMm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ERyOZJRo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GF5Z8EMm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ERyOZJRo;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769422360; a=rsa-sha256;
	cv=none;
	b=cI6r1OpIdt3gNM2E9nV8IHzs+icjM5ZWAbGDIpDDWJ/2cdrIVjfBn9Lc9nNN0kydONJfeO
	iCD//bV3pWgK0KwsLiCO50ttXK1kpHw663CB1cg+PkyOaFd0fQ0y+oQ/Ll1JoYVmW7V3VD
	o9nimGeTDOqXaIgMZ+bjxFMO9Tdpptc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FA3833745;
	Mon, 26 Jan 2026 10:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769422357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v1HyZXrYxupZ9VTkUvPpA6kmIimK4DCc2UwygBrH/rE=;
	b=GF5Z8EMmWwQTJaXUgNW1YolklFtrYrbUU2+LGfw/n3SsYVTM7QrqsIf7WEBNAY1txgPVGm
	BM88gqGkXoI8b/ybLe8B3Vq77u1Snas2iXZaMwAbzkhgOafQpq9t9w11teJEr4oBYoDNfK
	JWpYy29bDNwpe3x0BmqqXoBdnSWLOBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769422357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v1HyZXrYxupZ9VTkUvPpA6kmIimK4DCc2UwygBrH/rE=;
	b=ERyOZJRoIDUqHcIK3UKojh4Ie9dQR4w2njJPHv3rjFfiS8OBV8UVmXa8iCmY2TNy7lKP1m
	Y71hPNzeIYqsNCDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769422357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v1HyZXrYxupZ9VTkUvPpA6kmIimK4DCc2UwygBrH/rE=;
	b=GF5Z8EMmWwQTJaXUgNW1YolklFtrYrbUU2+LGfw/n3SsYVTM7QrqsIf7WEBNAY1txgPVGm
	BM88gqGkXoI8b/ybLe8B3Vq77u1Snas2iXZaMwAbzkhgOafQpq9t9w11teJEr4oBYoDNfK
	JWpYy29bDNwpe3x0BmqqXoBdnSWLOBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769422357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v1HyZXrYxupZ9VTkUvPpA6kmIimK4DCc2UwygBrH/rE=;
	b=ERyOZJRoIDUqHcIK3UKojh4Ie9dQR4w2njJPHv3rjFfiS8OBV8UVmXa8iCmY2TNy7lKP1m
	Y71hPNzeIYqsNCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F18F7139F0;
	Mon, 26 Jan 2026 10:12:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OuaeOhQ+d2lXCgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 10:12:36 +0000
Message-ID: <df8bec23-4ea1-4f52-995b-cf847ee9a289@suse.cz>
Date: Mon, 26 Jan 2026 11:12:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/10] mm/vma: rename is_vma_write_only(), separate out
 shared refcount put
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4w739nx169c8anmq9wwfoocb8uof1g6e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71CBF40002
X-HE-Tag: 1769422359-686128
X-HE-Meta: U2FsdGVkX18J+Zx1ZeHlo586NuFHonF3MQobrFvQRdp8wK9nh85PvRd0GmD88E8K9vkVp64wfU0fiGCS5PKlKzfWFwO54H9CrvQB+yGjTc+FRCnNUM2gSg6d8PZjgm8PzjaaztqUE85y0rXm17QZNR0XrxPj+FAoVJKpJ4pMYazyVSRxIpvfhDY+gIkp0vXYdlindPVo8zKIkQ7/O03Aa1QsbVpuFZuA5D4D+xSAHEYbR/2YqQEqIO8M9tJNFSXacsu3QPvnSTMPZxRSNkNMn0CLLsMDg8RPhlK7xVg+mGxI8cMYv3T0InKCeykFKwfDpqtCzHoHELLgvljRsKeOY81u6bKn/ijHMrN5LyV77BFmksk0Kd7rCKH64HbUpiKrWRip3hyYVX++vVIdOliBQQkFLHL4A5Ls9wUkFX6vAWxCKFO8bJg0qv0OQDHny2TO1sCVkR+9qTzP2GyakHIXpClba6aJgm9Pg7FvU9QFsUcVZopOxC0jGBxXW9tj6BuakVyUE5308i549okTjbRZNJV1bD8CFXppxpcCG1o6cqevw9J0TbKDHESPTmxRur1nYeLr7RZiWKi4sU9NLcOaIWBCRld7DBq2gPgNWTQ/PDSAft3px4IZGDrjrqogZpW7JxdBUE7DKEGxbamonaIJlOGI3dwoMhoUS6PuUJ5CKptaJC85ffKK9O7MBlWAngiiEv47w2s/r6L1ekOKM/pKE5lb9g28Zhbr620D/51jiUDqrmqbU9XQ95vzyYFc229w1GJxrL2ceYtuynRPFjNrqftsbmkYQnq/Hht4gMeWWuYAbrgMcfXJfA6OsLm8pkIiKYoMRJLHNoALNSQJKfMLmS1xu5rU9QGtTtk5+3ZudOUC3ImVjzSnh9GYQb3/pzGPpCcSD8+b62zEq7TROWOScFlrrp2rxSJEvOagRJmEyuAtKveGUBzh7LcsjU7OMLwRj+cNb+r8kfHtTMEbscz
 Gp4pESiO
 q37KydqHzm36mZQYA11sLLDfSFX8mtXYdWf4LmtS2Z4gxEz7bV9MPNh5eRMDKbVbALrljEwdWckjXcwmVeSpbC1XlykNahhTbEh3N8uQMLpUNdjDCayuu9MotLYv7CqPARCPGCC0iWXaDqRO8eKtYgC4/XmWiyBcMd/8tm8bziL5nYqnDHMKsWDf6+nZibM0iblSslAPDAOMLdIA7YfxUF7g2imOEEfnlE1ASD7Gz4q8AbX8u+BsKUkosd5RVPeXF53aI0rqWPsbisFx1dfKswqtJchHVY3arAl9Sd4iJWF1MQwCtImqN+KNTFwLkZHXOoOc5ztyPMbaz/aC6A1mEdvLNyC6eUSakfWvm47TgMJMWrCB4DZ2kCgETmjPNOSQOdAd09FJ0F09RO7M+TYbuc1dzakqDsuaHODbdrKLfOWwxHDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 21:12, Lorenzo Stoakes wrote:
> The is_vma_writer_only() function is misnamed - this isn't determining if
> there is only a write lock, as it checks for the presence of the
> VM_REFCNT_EXCLUDE_READERS_FLAG.
> 
> Really, it is checking to see whether readers are excluded, with a
> possibility of a false positive in the case of a detachment (there we
> expect the vma->vm_refcnt to eventually be set to
> VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
> eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> 
> Rename the function accordingly.
> 
> Relatedly, we use a __refcount_dec_and_test() primitive directly in
> vma_refcount_put(), using the old value to determine what the reference
> count ought to be after the operation is complete (ignoring racing
> reference count adjustments).
> 
> Wrap this into a __vma_refcount_put_return() function, which we can then
> utilise in vma_mark_detached() and thus keep the refcount primitive usage
> abstracted.
> 
> This function, as the name implies, returns the value after the reference
> count has been updated.
> 
> This reduces duplication in the two invocations of this function.
> 
> Also adjust comments, removing duplicative comments covered elsewhere and
> adding more to aid understanding.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>



