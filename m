Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCB0D2D10A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD856B0092; Tue, 13 Jan 2026 09:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB3E6B0093; Tue, 13 Jan 2026 09:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962036B0095; Tue, 13 Jan 2026 09:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 835606B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:13:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D596138DC2
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:13:46 +0000 (UTC)
X-FDA: 84327134052.28.57F0110
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEAF014000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:13:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yHRxIc+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aH0TFDY2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yHRxIc+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aH0TFDY2;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewxiBRrNZaYohALbXtEzfnX/Vk+Fw/hKhgUAJ9escIc=;
	b=rPPO6h2QnMVOqmMcBV1SQpuLZrww4GBRalUASqpmDHDbZMRgIEiMt8KloAtd3XslhIo/Uf
	MxQ16vMjqghiAJ2aT24A/hHLzGa3QWWlUVuyK/bMLtbs3Gd/2bgH4veNQ1fDvGMiMGQy1v
	hSUveJNj1rWg9HSU4ro1C7YmZXa0lVU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768313624; a=rsa-sha256;
	cv=none;
	b=qjkDH+2vtVP5MI0lemz5j3/IT3WdW+gKRaJohRG4/jH4B6fWO2oCCJ6wp+KHUteK+LlMID
	bAvbfiLdCORGD2No40UaE6l1d6vweq0g5bbyt46BfjEo+8US9axzc0CKRAROxBZiV8xcKv
	0P8iORNqITxK/sVJcsu6Vjxc2mL/+jg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yHRxIc+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aH0TFDY2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yHRxIc+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aH0TFDY2;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44A975BCCA;
	Tue, 13 Jan 2026 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768313622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ewxiBRrNZaYohALbXtEzfnX/Vk+Fw/hKhgUAJ9escIc=;
	b=yHRxIc+gpCkX+kfXAPT/3p6zxCILpG5kw/9eLTT/KEp292/gn8MUwH2N/xzuNAohC4ArJM
	pylQ7/VpyV/Gv6U1OUO95fB2TQBmkoHZ2ha+O2p6hRfDwfnhXy1MX79tENIHdqiS3pYg+4
	+zcyMrBm+T/PQd3RNYhI4spv2Bnp5+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768313622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ewxiBRrNZaYohALbXtEzfnX/Vk+Fw/hKhgUAJ9escIc=;
	b=aH0TFDY2S9oiLF/n9wDe+TChe6XDp2NllgSzFUlmgPcoXdO2XLCZP2UmckScBeKJwzM3Dr
	bqAxUPCr5JdMt9AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768313622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ewxiBRrNZaYohALbXtEzfnX/Vk+Fw/hKhgUAJ9escIc=;
	b=yHRxIc+gpCkX+kfXAPT/3p6zxCILpG5kw/9eLTT/KEp292/gn8MUwH2N/xzuNAohC4ArJM
	pylQ7/VpyV/Gv6U1OUO95fB2TQBmkoHZ2ha+O2p6hRfDwfnhXy1MX79tENIHdqiS3pYg+4
	+zcyMrBm+T/PQd3RNYhI4spv2Bnp5+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768313622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ewxiBRrNZaYohALbXtEzfnX/Vk+Fw/hKhgUAJ9escIc=;
	b=aH0TFDY2S9oiLF/n9wDe+TChe6XDp2NllgSzFUlmgPcoXdO2XLCZP2UmckScBeKJwzM3Dr
	bqAxUPCr5JdMt9AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29E0E3EA63;
	Tue, 13 Jan 2026 14:13:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wn37CRZTZmkqPwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 14:13:42 +0000
Message-ID: <11e83aa3-0ebb-44ad-b814-a76fd244cbf1@suse.cz>
Date: Tue, 13 Jan 2026 15:13:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 0/9] mm/slab: reduce slab accounting memory overhead by
 allocating slabobj_ext metadata within unsed slab space
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260113061845.159790-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20260113061845.159790-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEAF014000B
X-Rspam-User: 
X-Stat-Signature: 5nwqu1g69omefnh7y733tdo7wkzmaohk
X-HE-Tag: 1768313623-95787
X-HE-Meta: U2FsdGVkX1/qhWep428T/uSSHeEBfDX4qX78trcsP+EqCQ90VpQaJF8NqhKSDAiiRQQvcB6JqFP2GCPYMA/zT57x1W58ceUHwN1+KsExwhJ5bQ7RyRH2yiTs2IfYXnrQebSbpejKbo6BQ+VykC2ybQcbx96Cs3fGdlEpMedDKsTh95FUvokUhLQzduulBu8Kfw2W3pOj0V8INfNuL7SSZXFhm/ESG0Gq9rXMG0Yr277o4NU/VC5SFrv6PDBul0xJDGo1bGvssCSxaqLH8sUUgmlpAxQKJbo8QXzNE8WGIBlBtCMoMe8xg6ubStVZwXDtKiV7YdOYEAevzlJTGmMCBG6HCrR0u7pH/MJl7l0eRbtF5PnGMISgo7a/QPC9/MOy0qcrvzSW7zRTYguKPf/VuLfLeEoaYnbg4ir3SITKa2AevxgW2qCWxxYODQd1/NLgPOKDBMkmZUnn/iiauCJUPB3B/rxVg7CdSIg+ftDW17i/xeYoONxg9YYUhNKZhKPycmSNwD+EK04e8UKvDylfWeDnHG3wOyRpVE9Fo+SUAf01d4PPrxYxRjwE/lcWL2qpbCvGIVM4tUKXr1qCpmVf4U8kzORRI7FAHiqdoTlcGg3XuFHwd+OYN+Unu+sjaSWwWzqGIyDcxxs2DNOHwDlZBSTVI7YGt26CbXIAO3jW04wraW7E00ZbTUTigLzSV/8JTgnosmg+nXOYbHACfYBwZZ74JW+fR8WpVO5xliXroe1MAnF0ZtmVlHWkfVkp7QqC2XXIXLnDEsOU4JiXMKscYx75fKnS3qvcypuvMEWe7llSDlhEiohM0GFRhl3/LrvckBCcpA3PCoRUWpeDfKGseX24S0KKRb5IyD3Qll9vWu+GX+ggwu3YErXSbhYAKP0WC8nwAiMAUBj4N7NNYzuNqoOXwUUVXMvWYq0gjKC4Qjeojfu29XlyGdI5mjfJp91OvholEGh+y++cdZvbFqO
 4DxAK8c8
 lqhftX3tY1MZ/HR0pbXsuOGrbH1pXynQTCzAwdsgVeR/SgzGxRNX2rGogOP2Zuq2KwnDJiokPCvrGhRPIJcEkmUjx5PPRsVyr+Q3W+QCtho0BUhtWTtq5/q3gyN9o8eDGXQxS4SQgzxsYEHsyvZaQU33DpSEovuVmIq4xZqVAeGr2Oi76JFRfLAkoOkwoZM7w2BzKIRR9usv3WRrk/lPpgXxOMyWXPn++rB6cIP8MrPOseWT2tObKfD6tMh2nBIgUvKEl/maZNNLCiookga5DZ5xeuJcg2ybdE/qP6sH9uej3P3PNBwfwqX6MFfRGuEfBoOWvQYAzk+JeTc6DBPdXFBN74ottnYfZKh1dfyIRxevjj10tP9nV1Y492fxVSqjHSIUSnnW8GIlJUOwd4vsboizZhz7gemN6ZKhIfjZ5LrhreP3bxE2aT+mCAmH19jGv6vWklGoudfhNc8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 7:18 AM, Harry Yoo wrote:
> V5: https://lore.kernel.org/linux-mm/20260105080230.13171-1-harry.yoo@oracle.com
> V5 -> V6:
> 
> - Patch 1: Added Closes: tag for related discussion (Vlastimil)
>   https://lore.kernel.org/linux-mm/1372138e-5837-4634-81de-447a1ef0a5ad@suse.cz
> 
> - Patch 3: Addressed Vlastimil's comments
>   https://lore.kernel.org/linux-mm/e28c08e4-5048-429b-97a0-8d51e494efcd@suse.cz
> 
> - Patch 4: Fixed incorrect function prototype of slab_obj_ext() on
>   !CONFIG_SLAB_OBJ_EXT builds and kept pointer type in
>   free_slab_obj_exts() (Hao, Vlastimil)
>   https://lore.kernel.org/linux-mm/n6kyluk3nahdxytwek4ijzy4en6mc6ps7fjjgftww4ith7llom@cijm4who24w2
>   https://lore.kernel.org/linux-mm/473d479c-4eae-4589-b8c2-e2a29e8e6bc1@suse.cz
> 
> - Patch 7, 9: Rewrote obj_exts_in_slab() to check if the pointer is within the
>   slab's range, and distinguish by stride (Vlastimil)
>   https://lore.kernel.org/linux-mm/644e163d-edd9-4128-9516-0f70a25526df@suse.cz
> 
> - Patch 9: Fixed potentioal memory leak due to incorrect impl. of
>   obj_exts_in_object() (Vlastimil)
>   https://lore.kernel.org/linux-mm/8c67dcbe-f393-4da6-8d24-f9da79c246c4@suse.cz/
> 
> - Patch 9: Fixed incorrect ksize() implementation (Hao)
>   https://lore.kernel.org/linux-mm/fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz

Merged to slab/for-7.0/obj_metadata and slab/for-next, thanks!


