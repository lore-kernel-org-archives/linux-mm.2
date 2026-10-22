Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EC7606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=A3vEyZJn
Received: by kanga.kvack.org (Postfix)
	id 9F4606B0946; Thu, 22 Oct 2026 10:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAF66B0948; Thu, 22 Oct 2026 10:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1156B0949; Thu, 22 Oct 2026 10:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D38C6B0946
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:00:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACB761C00F8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:58 +0000 (UTC)
X-FDA: 85350423396.29.FD3DA10
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BA9140021
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A3vEyZJn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nTTF7dA0IAOUfaSQMNPTIUPCOpXWwbqh0S96Be5ADE=;
	b=Nxm48KNmU7oesvAAWeOK1o4EOHSneW6FCHkeHAaYkcRTs/dz+y+P03l+et2Ramg+zVHD7y
	M7wR55UuCzAWOYhl4jTrDHE6d1WDfH84D7eEslyMNbmbhjyZeTnh0EcIzEzoHsA4t9ZEHc
	Znkiv+WrtfqsPbULHaEys05rO6LcKtU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A3vEyZJn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677654;
	b=XS3+inYGSpby4ItK3zCSrTE5PJirO1EM9mCNiz0IyYEEd+cdpQYEgjurj707twIRaHfdsL
	1QmzpoNY9NaJMgrhlDb/mV4fJr1NkzMXLzD7Szr3hFXQVurlh0hA8MUaab0rBMrQZzNDuI
	vm0mfOEial6uU1cn3zptM6u62MFLixk=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35c76e9614aso3227173eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792677653; x=1793282453; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5nTTF7dA0IAOUfaSQMNPTIUPCOpXWwbqh0S96Be5ADE=;
        b=A3vEyZJn/gPZGx8tV7NNUs4qKJzQ0kgZvBr3qn4wSosLfN7c0JAIADQu82gNFoD3fE
         DIYOeRp0mmg/wx+gbKsP75lolVkorhpRaeJ0s0KkdOpv0mEUN+dFMzFdhHX9Xg9+3Lv4
         ScBAAd1owAMK5KLgYMWVT65zp0YQ9+zcEtXkX4RwksWQ+8+/VGbooWRJBfyMtcYcm3kg
         izh3TDBOYqW3/R9eVazNxFK1nhNhoEAFhs65rZGlXEG/NjOrWFvi+BdcBIx0JR+mvH/I
         AZ0P/pgw/G0zeRX136Mx5edkY09sXgqd6gaaqv4rNFd9IlLHXIzXZ2NEK9H5lrLN260b
         ytTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677653; x=1793282453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5nTTF7dA0IAOUfaSQMNPTIUPCOpXWwbqh0S96Be5ADE=;
        b=odqUGmZXqLzSkNK3rYOjkhxQqqHpBN0PqQGI9EKmGQOIWyzGGrYwJlw1mZaYDZ33kO
         QZvlQg1bZmyhwytaSRp+Ug8dyR1Iym+P3ofXDgM5kjQ85haRg6gFHe9H38qBUZJvEdi7
         3ZyptGYzR655Sx4oEytzNDA1XeOj+UhkqaEMfiQt8yuq4peqOk8YvjqG8JpSakKFLyjN
         EmuOrL6HAXJGbnSlPJ92FwMXFpA6bP74cjLMX2u8u3WUfu3ex0wNYomkoC+4yvQxSN0u
         Nk2TV40/ycaHJ9Zjdk+rdZ93YFunsT/Ku4KmDvX8lRlAVeOOhoVa48XVaW5nzjQH6fJI
         6Q7Q==
X-Forwarded-Encrypted: i=1; AKwUvByxIZbCuriyjv0ZBZiS6XGOmFJHcyMWKjeSRj+hQPQhhP/0OrOpTZnVxCEzEdWZbmmocUq1hty4iA==@kvack.org
X-Gm-Message-State: AFq9FYLr3BS1XdJkZuyR+NKFtMp7wz1cwRqbaMpY/P1MG71W9xn3i77Q
	meGoPW0b+0UYLjOejnntI9JxgHxgoq2FgXoG5VgQSKEDITQc7WAIhwTG
X-Gm-Gg: AYBFou3ZuqbhnFjGUtg6MNkUWADDo6ixFDjPumRARG5CCmlHvcBOJrwGnYJNq0unCPx
	zbreMHvQLDvCDP6aAXdJugAwxjkNg5veS9ZDQ/pGUzN54IVwFYqaO5pT367n8XV4NdaRkpat6iI
	X0BGNrwP0D+2fG9aLaonfDYVHtO7OCJEMZDHYFKXjIcVGiM9R9DWHXkGlBph/2eAq8JRKk7YQKQ
	WWnvsnvGHmpbPmq93n3bDrSumQOP9oA7pZo0G8HvCELyxMr7eK0vVBn6NlnDQAMZ32R5gU43nPn
	C/cy8HJr5sA7kvDlE2UNDygh5mAnhnk4q7zdHI7Z5WTPkYMScq4HT3Uv/SJ+9Lr8lj9nYNXJzOi
	kwq9N7QNFe+4e/Yc1lCyweDBASpb+tLnKGx7N/fXBJHPP7qo2kKJ7nOhNlkZuPYLvucZ9YCzTfG
	Vp7oeiua9Teb85MxohLPBrFjTJKTC2oqVSjvfw8WQgXIju7pUmHlIXtcFcL4HBmwe8iQQp0/vbF
	YSXKqNd8bfLApsm/L5hpWW5QmvemBUVcaG5rJdSG5Vw2tRr+plXfr3eNbYU51mnSBh04PqW
X-Received: by 2002:a05:693c:41c9:10b0:35f:ef9e:f846 with SMTP id 5a478bee46e88-3674b531987mr7142175eec.3.1792677652558;
        Thu, 22 Oct 2026 07:00:52 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e15353csm29420342eec.2.2026.10.22.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:00:52 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 22 Oct 2026 22:00:37 +0800
Subject: [PATCH 2/2] mm/filemap: extend VM_SEQ_READ readahead below
 descending faults
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-bug-mm-mmap-readahead-descending-v1-2-6d08b34862f2@gmail.com>
References: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
In-Reply-To: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 8BA9140021
X-Rspam-User: 
X-Stat-Signature: s9krkzeprpxq38hupt3pyd84txtefzi1
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792677654-980031
X-HE-Meta: U2FsdGVkX18QZu4DCjRZbf2KgJ6xDFY8mjt8EIWtkbPlDrBPAqrBOKFOh1F7p0a9Qgx05EXgaQbjugBADIdEVq7UWc+U9FwXotvfTKGrZVq96jaeiSeShfglNUvP33V77S3Vixn1O00FOa4kzXTsYI6Sn0y0q6/gHfYknVGpbTcVP2yREuJbEcUMbRXe/sKFSdqXh2XmqvqaRtD+K44fxNrKyvgk8gzHmFNgjhdu56L6cmSEXWtIcgsDxzPzEqqcgekWDGrWz3Y+9w9LZqPcwHgoueJM9YYcmQwJQJj6TkSa9AIXkSE9O9Sf8bR6qq20m3VsU7oRWqA7CNYlMoUDRQKzSFIHiw7+XNJtmxpRGrJ9OmOYyf71gEHYw1r8xXaSqkeB7rQ1hNHliiLT2LC42phNZkGT6qUtvWjK6XpzYLxdsZlRBuxvxOW1cN2N8SSW0dquHpuerAdrp/8ELIG34JF1PsroCp6oAdtU0k8gW7qI7YviSYszkM+8FYFXxQyCQOABw6oPe3VE/AcvMFgNOwEu2kSYseFkMhvFB2vnX7lG2oDVr29hwdUrOUp7/K5VzSWLA9nc/hiK9YmnQ3pBpdfOsMlylRBBpPrzq5jwnp1O6WkzqM+CVFNoY9LQF9n/Xq7ocICNiMAaU/j8nV7k1T2UftPsal9RttQadUw63QVnkX3n0EM65Gznpr6aBajQbmSq69efIpkLRyqIcJ/xiItLllqfyU/u0fbyt7AaXD8Xq/JckG8bFiRI43mxe7PuFxURb6vSftZwNy9NpkGjBFMP0HX/Ssj9sI1OCfRn1PYOmq5q9TJc/2RaRH/bIJBQjdd1ctrw/ot1xEemqZj+/geXregITb0AHEtE4Q/tqdTEBjfigsOytmXnRjIc6P5AkqzGDWB8r7hSDUrdQqvDQXboKhMTpQaDxkQmSct4uWRgQHaVeLl+VM7/zvHPUHae5rxn8NoYZaXE+Ujv91l
 Jt+61qTq
 wWKWfG3v1x0Yp6V7UsTijeALzqZhwN+3bTpgW4+0g9L1uD6mlk/mXhXG6cPp+EMwgchciFyHgpTOKriFEJNBZYuvM0o7TkgzSTFzkDcSQyYPAZb8jhLRqT3MbbIqW2arA72b2UNSpBS7xPWWLqRVauv7e5QjVvSlrW2EDo2JH9erZeKQ4DpZ2XPQJiy5ly1RGkzWdeO1J2qvbfVR2sn8rSK6WapOleskIDeGKtWdnv6xsUWAPFDUBT5ruuF8v0rnZ+vWFrJurebHDok/LjbJ2kMC19G6jji5qD58I6HqO9bSzT97p0I2b8tqgrYOF3qp62+YK7VE2FBZR3D1C/6pDE3ORbWbAXNKYIypf19DinSSLBi9npOm840Hc7+FZd3MUTuLcd544Ek/8tETETuTWj29EbjeNIcC1Eb/X8AEjhiSJ2tNgyHoqYbVj0suN/+8HhUcKJMwcyhS+8w7P3x5DsFXhgvOfRNJ+fl+tcgV5FhD8gQA8l88pwtsmxgO0sHH8PPBqugITTSsygsqghe3SV18evpOS5MT1nRVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a VM_SEQ_READ mapping, a synchronous fault reads ahead from the
faulting page towards higher offsets through page_cache_sync_ra().

A reader that moves towards lower offsets, such as memmove() copying
backwards out of a mapping, finds the pages above the fault already
cached, so each of its faults reads a single new page.
page_cache_sync_ra() also looks for a stream only below the fault and
takes it for a small random read.

When the page above the fault is already cached, read the window of
ra_pages that ends at the faulting page instead, without a readahead
mark.

Reading one byte from each page of a 2 GiB file, last page first, in a
MADV_SEQUENTIAL mapping with a cold page cache, read_ahead_kb 8192:

                   before       after
  time            50.28 s      0.76 s
  major faults     524291         260

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/filemap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 8a7d1238ae75d..62d507f96f22b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3384,7 +3384,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 		if (vm_flags & VM_SEQ_READ) {
 			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-			page_cache_sync_ra(&ractl, ra->ra_pages);
+			if (!filemap_descending(mapping, vmf->pgoff, 1)) {
+				page_cache_sync_ra(&ractl, ra->ra_pages);
+				return fpin;
+			}
+			/* Read the window that ends at the faulting page */
+			ra->start = vmf->pgoff + 1 -
+				    min_t(unsigned long, ra->ra_pages,
+					  vmf->pgoff + 1);
+			ra->size = vmf->pgoff + 1 - ra->start;
+			ra->async_size = 0;
+			ra->order = 0;
+			ractl._index = ra->start;
+			page_cache_ra_order(&ractl, ra);
 			return fpin;
 		}
 	}

-- 
2.43.0


