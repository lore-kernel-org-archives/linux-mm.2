Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52460CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF608E0006; Wed, 22 Oct 2025 03:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897038E0002; Wed, 22 Oct 2025 03:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D41F8E0006; Wed, 22 Oct 2025 03:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAC88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:13:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2067B1407CA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:13:50 +0000 (UTC)
X-FDA: 84024885420.20.372B335
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00EAD20004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:13:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Stn6G0Oc;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761117228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9zwPnIO3NVOP/cmDlK60nRyQdcjIpG1DboYa2VeDdU=;
	b=3P3QF8kx0AEDN2NXN9NbpiLrvu0vthTN8CxfC79ulrItYu4JyaJAkDDPEbislc8pgOHerx
	vMeOmBJaPRGwpsptsi8Ttn2AXeiKDXESTC81ETV5Fl66CLFrH3uYVB8z7T6SWSDbV5LX1F
	oDOjZ+d+qYorkuLWQF6ocarPLkRmG9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761117228; a=rsa-sha256;
	cv=none;
	b=MLAcXhO64YECLrhptBs5Y0B3LNm90rXDW/mnXr2w7jKMc6Mbm2ssw6CcAag/vfa99Jprsa
	Bvw0Ld5itjZoNgDx1BJJMEJYlWS8whc1AZAKaihYzcBKea7ODAUmjdUEICK3HPMgOS5UcZ
	9HxynebMx7mQA/MQUmZT5RAnVYWycqA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Stn6G0Oc;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b5c18993b73so1039062766b.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761117226; x=1761722026; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9zwPnIO3NVOP/cmDlK60nRyQdcjIpG1DboYa2VeDdU=;
        b=Stn6G0Oc5C7joH06Eme65jiD564M47U3qSbHnjK4nludASyTiIARNuVahhfWuDag+O
         /8Jy5o1xH9Oiz/6sbw33ExwpFCUX3G0X9UQ7TH/5QTSh9gmYDtLJSlujGp2WjItqdKvW
         rMFI4gZwTMvO619FiqlkeeBH7QMvv+ShYcPTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761117226; x=1761722026;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9zwPnIO3NVOP/cmDlK60nRyQdcjIpG1DboYa2VeDdU=;
        b=IVMtAMj2VpY7oKMLyTtAJUvO7ggMGrDWluT0OAwPsBh8Eaw1J4kzsxt/A3uYk8oRwc
         jTGtWjfjoLIoipuQ88W5oNI1nEYtP0JM7WoNPLd5K/SHwqC/cmX9sG5VOztgH46S4K2e
         zwGNL9kqLDp7bO+4p/YgwUJnqrzlLLU59bWwpCzTKlJXMlDOM57DObLeUm4anX9VGXaN
         Mkf8KQn54jMgQtszGfe8ucHlQpsJtvJtGBw6zOOiJSsC1huXp87ELhCA++XerBGoiH/M
         NdIeJf13tzi0u4hv2dc3PkUv2c6vZAO0njM08dwi8wlw9inS+Sta1yU+8SlngA321rBY
         hBEw==
X-Forwarded-Encrypted: i=1; AJvYcCU+qGOKjqVxWudCKbZcXBZGxmBkQdUNpm8VL/APt3iOoxifnFEWxuSI7ha17E08LyY0jUNZG8FG0A==@kvack.org
X-Gm-Message-State: AOJu0YwNn3gFlRA0otENJbx1300XwcA33DMLNV/YajKrGoF6+xlfh/tN
	/5zTWmyUxztOVUG5E3dsAmMeDAFaSpaTjUQBlSe+b4EDzn+BinR0fH2DTCy238Nf7pELD9wQ+xJ
	6WMJJcVFIdg==
X-Gm-Gg: ASbGnctnXoCYDl+OOZ98zILJs93LXc/vMz+piOB7IBXcoaCNM9D26XqO0bvjOr65fNz
	W1giFgPTHg5xDusbY4FNVK+mvM8v3+NzK0JXULULfD/1IcrulIrPSL4v9QxEMTi4+tlTFOXNaKi
	xE3OjBgVGMRx9Pii+5IGZ8eKtPWuJxmEpDcB8bQojmUkpUEU6gOZBOFwiFSAsIhtaCZWZKDxSer
	OGjxGT4houccQmN9A3lJGTNLUPQNaym5KeC3ApW8g9TFqGe9TM5tmPpNoi9yNgFzDHruwql7ysM
	Yxtyf/lS8AxREQ1uOC46bD9v8jD1fU2/nKt3Gn4lLNf4bNsAfHixcwy+6uBqZI3wrJVF9uXVde6
	Ps8N+beXamq1tWEw/nvSom8b7pERAs0vUY9x8MmmB/op76LVOp5wLaFlykh+hVXJcZTOIJdanS2
	66ojq6k6oogg9cFm0EOaGqS5qrtVLrsZAjIp2iyVv8KwrXNoC4LQ==
X-Google-Smtp-Source: AGHT+IEmxQ36AM0729iZXNCFFAzS7lkxC88ShG5DFy02VkEh0H55PIjgwHVq5cVjlnhIkhBIJ2XKDg==
X-Received: by 2002:a17:907:9411:b0:b6d:2682:8306 with SMTP id a640c23a62f3a-b6d26828548mr531345266b.23.1761117225989;
        Wed, 22 Oct 2025 00:13:45 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e7da25c9sm1287171766b.11.2025.10.22.00.13.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 00:13:45 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c1413dbeeso10302891a12.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:13:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWFhYuzcUil+vyLTYfbb44gsDTh4rg5j8r+Klhibv9AXOf2J2U6ioAiUVb+qFDOdanNs/auY+HOjA==@kvack.org
X-Received: by 2002:a05:6402:2706:b0:63c:3efe:d986 with SMTP id
 4fb4d7f45d1cf-63c3efeedb0mr16580891a12.35.1761117225052; Wed, 22 Oct 2025
 00:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <zuzs6ucmgxujim4fb67tw5izp3w2t5k6dzk2ktntqyuwjva73d@tqgwkk6stpgz>
In-Reply-To: <zuzs6ucmgxujim4fb67tw5izp3w2t5k6dzk2ktntqyuwjva73d@tqgwkk6stpgz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Oct 2025 21:13:28 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgw8oZwA6k8rVuzczkZUP26P2MAtFmM4k8TqdtfDr9eTg@mail.gmail.com>
X-Gm-Features: AS18NWCVkJF1NOqKWFU0gaSGK8tjMxXG8WT0XdrBzJSO5Q7qcLLOOQSVewmJNPE
Message-ID: <CAHk-=wgw8oZwA6k8rVuzczkZUP26P2MAtFmM4k8TqdtfDr9eTg@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: bubfa4rignuxkqfrb7bbw49699d13pu4
X-Rspam-User: 
X-Rspamd-Queue-Id: 00EAD20004
X-HE-Tag: 1761117227-15957
X-HE-Meta: U2FsdGVkX18xQqf48G9YW5F+b4tNBOgFBkpw1sULtXhIJZjaI6m4jXTNVxwyjcAJ809ziMSw9gtjU+JIUAIdH0ZZuN35dmRmv74nelnCoEafD4pR+HBOH9lhAsoz4A+No2G+UoDpKcmwTU8Dm0W3yU2RiQvryBszvuGJArV8WUiR35XPFWJKZp/X6qa45qW4EOwGaoJuWhzBQuShKzrzpQZFhZHf+H0nnY5dmVh3kTfzTIFafgWSZUx7XQ2nxSeqnuTXvjpD6hxlil5mOPiRBcgXYlSHmHr2TD1PvBPprJJlwkbynVBh2qAdIlvQ9BE0BSsz73ojP9cXwbTKYRWTwQxvuOOXeDziGWXunU6OBZdiziMltglZvULpw97qMJhnRyZputtLEaAjRkhNVwXpFIf53qSPKUWoOMZH7iqIuNjpbw5r+YglaiPvNU8+DxotTma8Z7Q7an/PexHGvRU2JFTXpQx+jdMFAhWyP5YHvmvLrCZNmbG7Jb8vA2MZIx7CH21VrLUQyL9+HYgQiOusEdwsIrpUJ9UTLY7NNR2q5VsndVKV+KK9WJYl6NVfQaCBIUMuX0S34qbAQZsqkqG1gcs5zQER5yLmNUCjUxv7xPbdEpLKxXf9wG0EJesj2A6udUL7ph7AngsZxkt0p+N7aEGX/MB4xrD6Ka2bfb+to6F1yGnpIOvNsS+4jxfixVD+diueX+SCWPn63D9dmjBI2w9ROu0f/E4SF36Gr5+XwXU0f1JDpsefCEHXCZN3j+Y1csNEgriP2tx2QB9M/d8K0Qm/YJa3F/zI/Qwj11YnUNr9hAg1QizbAxsqTuJn+ebL+z5gg9JdOCfjVqiLGN0dNJmAIpVbq9Zlqkz7K63ypooJV2pObjZN9giFRONPv9QcXb3vAPjyNAErW2IxhMPkR2CBsBqQIytaL7PHPOSAKgbWyziM2zRsmvtA911lj0so1h9opM5aDL4EJwZL5GL
 42rYr3Ao
 qQhylOZ0N6y6HLHXbV8pfkZ3jNBoG8j1XIfmUq+KeF2+Ur8eHwwe3sd7i32fvZv13kQ3bveiz/swTMBVfMWjrZcT0QUOSKkqc8LFogaV+lUKg7qBKM+R1g/fQxrZd/nz4Ll6DnpxIShVeFC+DsPaycjxWvXO9WEMtYOx2bA4OQZb2WSDfA4DevHfgIdJgfJJ+ddYIu9xkL7hWq732YpRqaeX3PKXgle5TWFZ7egFjYQcqXHoGfSsHmwC0W69VhMD+HH/ZmLyi05xDe6HT8jXssQ3JtUiseKWF7Xv4rWsXTUdgjWAtVkpxPQFPefxccyN187n+b/wZIoAkjpfCu4x/ZF3WXz8cIZc4QKYQxh4qfRs/iXZP4enqUOFJlFmyG7Yzp5rzDw10UYixdm8iR9HH+D3malvyPs8usiFA5Oz2k86Gdb8tmf5BUIXPVBHF+pLUqTu8AiKFQCdtx5/MnyAC8zAxQ6AtEgmCkOPYHm5kzH0UTTfAbhV3WuatYRxQtEbb683S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 at 21:08, Pedro Falcato <pfalcato@suse.de> wrote:
>
> I think we may still have a problematic (rare, possibly theoretical) race here where:
>
>    T0                                           T1                                              T3
> filemap_read_fast_rcu()    |                                                    |
>   folio = xas_load(&xas);  |                                                    |
>   /* ... */                |  /* truncate or reclaim frees folio, bumps delete  |
>                            |     seq */                                         |       folio_alloc() from e.g secretmem
>                            |                                                    |       set_direct_map_invalid_noflush(!!)
> memcpy_from_file_folio()   |                                                    |
>
> We may have to use copy_from_kernel_nofault() here? Or is something else stopping this from happening?

Explain how the sequence count doesn't catch this?

We read the sequence count before we do the xas_load(), and we verify
it after we've done the memcpy_from_folio.

The whole *point* is that the copy itself is not race-free. That's
*why* we do the sequence count.

And only after the sequence count has been verified do we then copy
the result to user space.

So the "maybe this buffer content is garbage" happens, but it only
happens in the temporary kernel on-stack buffer, not visibly to the
user.

             Linus

