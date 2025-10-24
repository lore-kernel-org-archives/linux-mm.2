Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1446CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 10:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2453B8E0076; Fri, 24 Oct 2025 06:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C498E0042; Fri, 24 Oct 2025 06:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B9A8E0076; Fri, 24 Oct 2025 06:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F03738E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:34:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E44A13C40C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:34:39 +0000 (UTC)
X-FDA: 84032649078.24.5EDD1EF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id EDE372000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:34:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=00cHZpNt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FNG8rIfd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OfhkFiW9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTWMm2Fu;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761302077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hla0BTIIhUzpRmhnkrQZDtIDhlD9P51oxgHHRym65RY=;
	b=hwEZkr/dPMBBaklhUrEnyLhHglSs5Oov+owWN1gQqK5h4urWMoEht6FvX234aJC+keI3Yl
	wJSKiu/p7GBH/BquMgjV+0ovdQofUKbGZrBbA/Yrru6nFNrwP3zIYsoscUsku8isih4EaD
	XwbMH4ZuzbLnaOUCmF39R+fJVTkFsV4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=00cHZpNt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FNG8rIfd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OfhkFiW9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTWMm2Fu;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761302077; a=rsa-sha256;
	cv=none;
	b=J8YoM9lLvsUUTYzipwNAroEnHOoHBiLXVl9NWVioDPIS68GZ6B51DPKYVhFq6jvkA/7oAJ
	23iImD2Cky/728l3zSGs2+pYMFPbfhZFILUaae+SKCHWJIWAKz4nl/nQ8n4wtQvIan6ZnD
	9Ny9r0hEFL1hpWkkef9eiGXO6+VL12E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E80E01F388;
	Fri, 24 Oct 2025 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761302071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hla0BTIIhUzpRmhnkrQZDtIDhlD9P51oxgHHRym65RY=;
	b=00cHZpNt7bFmrlbaRrwf0QYTMchbl/qTVQlklcXFKsUmAB9mbiFKGMpOb+aNo4S6oOrCKf
	zHzgg9RZDdou8uPTjpIfuLoSSxQjmIfQzUhfaVlg6uHJqK6PQpAi3ZGJF6Aw3d+ZLD83Iy
	iIWUFKo3VVO2A9Wcbk4vkMIGKfB7v+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761302071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hla0BTIIhUzpRmhnkrQZDtIDhlD9P51oxgHHRym65RY=;
	b=FNG8rIfdRoSH7c6RI/6BGVfNA3qDv9Qx5cyWxABk7nUY1kZ0VTcCNT5v3hgoFyPLvAXcdp
	LQnTTRkSl/XQ2UAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761302066; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hla0BTIIhUzpRmhnkrQZDtIDhlD9P51oxgHHRym65RY=;
	b=OfhkFiW9nNZaBYi4At+ELu41vhHf+2s+O64j8no9o77Y13f+tcGu+n0YY6TeHo48Wt8eRX
	VDSM277GGmdA77oZ065mZdx5h+0410S4oBtBS3BQniBXxRGyzff0pOYnJCgAeWEeI3LXmZ
	2gwnfnI4b3PCdGhg7Szz/+rNNV6H8ps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761302066;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hla0BTIIhUzpRmhnkrQZDtIDhlD9P51oxgHHRym65RY=;
	b=qTWMm2Fu+VEQvLG1CL+S3Kt100fU5dL3LPqP3ItESnCAzYvOgK8/ZnRlu+Fc337BL7W1xr
	SoJ3niECJdpvdvCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D28D713693;
	Fri, 24 Oct 2025 10:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S4YcMzJW+2gpVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 24 Oct 2025 10:34:26 +0000
Message-ID: <804253b4-5519-47e8-a362-bb8af06971ad@suse.cz>
Date: Fri, 24 Oct 2025 12:34:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
Content-Language: en-US
To: Hao Ge <hao.ge@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <8b152d73-ecc4-415c-acdc-3f5105412ac0@suse.cz>
 <123334B8-89A9-48C2-BBD9-A601E0395AB1@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <123334B8-89A9-48C2-BBD9-A601E0395AB1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tmjrkrcjih8sn5x9d6wej65rk59nrcj3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDE372000D
X-HE-Tag: 1761302076-848327
X-HE-Meta: U2FsdGVkX1+Pc/39W4i7tN7tEDQi2Bx9uvhpn9XqpW7uDhseIMxdwzi4HOYjf2HzPgv5XSlE0m+bGKlyzH+8C1Yd7uNVeKb+AKnmN8SX/NEEfNwel3uES+zLFwiokRzQ8xtleN6wUvHvTWtss5C2xWzT7nZ81ZBfiXsMRItuii7+G43w3rfvlvMZP66H2l6Sk3/yGH7nKbYkovSB6NqpECD5sQ7Z8SCu2bcvofIaFnUHu8cAQ0/vpg2/o/9L+dOEuvnx/O30jiUYOU6yVMop5gQW/xCkZ95JrYoOr7hp77uejf3ln1k/p3AJ/gsJ28ZendFtde5dvc+Z4JqX45pQk4+y1Axv6DsOHb27jeF/DH4grx3LKZ0cm+gS/a82lWVjcBzr1/4vsWxNa2eJ5r+8IYEbVIzvQw+4Bi5VcSRe7yP2AjS6zsLISFue18dpUzYXSKvZbXWj0qF+v/KR778MadkpuzTllB8AJ92llmWoJWviORPq6KwO0z7NG7GCCaymCC4UqXL9L1htwbrxkl1z08WEyeLZ2xAq0JNNqZJnzXfmKMO9AL2gy1RGGMbaW2aO85F9kvz1kqC1gjKNtRN4cOcFZfjW1ZKpKurz83mAJLzeq3zhT1EDQRQBCEBymaSayrdNq96MH381AvepkPszmBVVx6zAaPHGDjO9z2Qvj3hmioNkyFbgR9zf7fLWxyjQ7H/c4ljQzlkCVtMPT3qAf+fo/wvywFbNGJh0zn0OcFFqUCcXySjhE88fI4oV56qLzSRLbqWo2ZOK+elemIJckEniGXXHIOv+sRgfcEaU3lB6GIJ/iAiUQyaZW8Yqr8RXpbXSnuC9jGJQPVkdlvWY6eHYE5Ukbt6ybbkhVVdgreIAqiadhRqg++kYcJ7lap21irGrFnzc0TetmbyVVasKBoZIooXm84CnvuDS2BT3/B1rJsZHXwWI6Eomdwzvtd1OdkGF4NbkFWInRHgne5f
 uIIURS0B
 I5Xs7Ic6w2JENoKlmoGwzubdFinxhL6RGl4VOmBMzMNxk1YRrSYza2x1h8nq1RdPOkk0h/F6seb+MiyoT3Oq+rK1xLYSuiKhh2tn4gpxaNH3NqeUKw6McpYGngHYGf6zJ9r7Ys+dTouKv9i+JfVmOEZoRZSiSkqAVLnl4Sswds7mx3KbDgrXml9zKUjhbfI5QlZPqF7qdmg5Qz2/GtT/aw07iqB+Fb5wK40wZImwXHpOgkC/ZCCBGXktcL7kRn5LnMhkwmMC3Ipqx680WZ0zc55FRk70oUJgrivqG+aexFDZAYoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 12:06, Hao Ge wrote:
>>    }
>> 
> Thank you very much for your help, 
> and I sincerely apologize for the actual trouble I have caused you.

No trouble at all, this is all normal review/maintenance process :)
Thank you for the fixes!

