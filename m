Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2A6C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684B76B0092; Fri,  4 Sep 2026 07:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CBB6B0096; Fri,  4 Sep 2026 07:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C396B009D; Fri,  4 Sep 2026 07:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39D876B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:35:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3C4D8054B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:35:42 +0000 (UTC)
X-FDA: 85175874924.15.B956113
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 253EF180004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:35:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFBRjMo7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcDA25eI9y2B2WpTSeIhx/DUa2mm+Vv6g2Bub0WswK4=;
	b=S/Nii2goOZJDAo8A5atbXJdl3rcxyc0GwAGapOl6077PZ/rVEl5uKT+gIg+7zbpCVmDN+N
	j/KNdhXzWkvU4a67dd/Oqvd+H86Zc57Shpni0ETY8nRqgsX9JsaaOGHwoCADRY9gh4edul
	PAQzdC18CNPO0TaM/a4OaU6hqp4a+2U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFBRjMo7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521741;
	b=0f/89SKuZNmbwY+noZgjpTkJ+nRvwUa9NkF2N7QJCc+KVHH2S5CJyXSBLt5yH3IFugwi0f
	3LkImkymfK/XRYBu+snaONrAMPhWUbsIcLTDHh7o+XGweno9i1KFXgKRmxE4G9GgG4vQWT
	bxGRozhDY7eofwPVR7ptJvc1QtKVLqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B11C4600CB;
	Fri,  4 Sep 2026 11:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0891F00A3D;
	Fri,  4 Sep 2026 11:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521740;
	bh=IcDA25eI9y2B2WpTSeIhx/DUa2mm+Vv6g2Bub0WswK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HFBRjMo7FH0t6qu3NNi5JZq1lN5r3Iur+LHpZVKTr6CGT2pXSVX2hq/YGV1pIsAeV
	 5dd3n5g5/Zz49iuCCac9P4ufMnWZtBxdyTjt4duMYCb5tYIKIId1eJIL+A3E1L/3Y+
	 Uom/bgW31pM7ugrdaBgFvdZPBsZJr3M0sE6EdQrNdZ7grDDL5EQurgKJy8OQw2bPjk
	 PrAKWoLV9hY9extljzBXYTfuccFgrUYwfM12jzFoud1wA0VFjOzntrneD5x0vp5Qe2
	 pnWNs51XSnU/s18atA0ylBZSdDih+zVjSObhw9hyrQmGJ0k5h71q1DGVSlLfHgwubs
	 0qmY3Xr9oGHnA==
Date: Fri, 4 Sep 2026 12:35:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 4/5] mm: fix typo "mergable" in comment
Message-ID: <apqs_3dd0oXh2zUo@gremlin>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
 <20260904104854.25272-5-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904104854.25272-5-hemanth.selam@gmail.com>
X-Stat-Signature: gupih73owodfauaa4xjyxwnpa7uqs4aw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 253EF180004
X-Rspam-User: 
X-HE-Tag: 1788521741-926622
X-HE-Meta: U2FsdGVkX19JuasCr8LE7wuoyZPM17Ky4lMDuC3uFp0eL+bmz6OckBVAqlxB65f0wB66TcK3HOLZna6yhKFiC35gHHjFyfON5F9miCi6ZTwxlyW1UaOy+Hv+4uacfK2k6U9F/8AipTJvj9Fvh/WmPlwQXcfhv6T9lWeAANsszhTCVI1fNqWn+bG5AVxm5ymNZzrUX+DPTaeE2t7uePFGl2yHbyxWVWf9M8W77yC2MZNeOGX/YWYqiJhUBGJ54adQX51xZIp+djxIuGNyVpkhmRu7rbyv6d9Yi6XlbJHUXB+Lwc3dd2obrK3fi8tRGENmPTNspFsXEkxn/ANlsmQ7fsHe0fawNEYGSZ+cwzIhH6PKz2ChF1v021fYxuSTL9sHe01kWZhNFGPDFb2oKAzQe4QBxek1RBu6LCgKXeNm/PregC9Y8MmgLj74sLf36w/DwbTtXqEgOh9NvwJSN030vbkUtITRl7lNic+uL5KJLofm37AvMAI9FFHffzwYTCtHzuCNVr9kORYnz40pG7aUxPemeVEpzbvhjY4cWDrhSfNiwahKurGENceCdjaK+mT2VB+0ZcJ+B0jRzI6Y9YY8gMwIniqvn2v7XrbMLC5QeH65AkVktQb1Wqx1vEEv/DlvEzVGHe+WeTv/1FGru0yFdjLkYchs8nUKs1lMyBSTlQW1HVXGIFOvtk/HfHR0yLO91mJyrUblYTr3IsbJj4uBd0kLIcAdM3ySmasEynbERr7NW+TYgPvrm9OB+TwH+gtvl8ip2mYFChrhg6OtmuGA3dVgTOsgrhGkrfGAUCCO4VpyB9nz0ptymdQqCC88Wy2VJlxL6r+MyWUiVU39u9MYMWdqg/OKVzhKcVKkyUsfBqx+YduVV6plJgZvpyLmdh4bASghoEDBtYwSBoIzSrd5xwTkoFMBa2Hcs6vUTBhL2dUdl8lGc4hDBLnW3+rkZmly62dkdcH/MVoUhfAn98m
 ksk/JNzk
 ciZWFFzQtrLphW5wrRdYTo+NOpV4fPM+vnN4yylMGgDExgml8U0wURI3eElYKZ4w4WxbcgbRQosVrtwwSrbKHnXp5WRydSKMshUSFZ9z2t/iyhmcOpFDaoj2XCSbVehuImY08azXW9cp2vvXNUexBvZpXYUE924yKFX+9sg1Wyv1L6hxLzaXnsd+bKQ8hXZkwDZOzEmwhvQjM3+8ipTinGmZuYlPXEuOEQFdYgrPlZUygzg3AwTNlwb2/EZnBe1vgH/xYRKP6MK5NaCTLmLLRF0WlKKXRM3IfXCYtI9k42w3x5ZxQ6pUhYYH+MjVFPd3mDjN1LfzR2aIo2cmdzWS/P3sxSOSEq6u9+stt5RDIRbCRJOHqCe6yIxWnSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:18:49PM +0530, Hemanth Selam wrote:
> Correct "mergable" to "mergeable", reported by scripts/checkpatch.pl using
> the misspelling list in scripts/spelling.txt.  Only touches comments, no
> code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..5c856b78ddc2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -587,7 +587,7 @@ enum {
>  #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
>
>  /*
> - * Special vmas that are non-mergable, non-mlock()able.
> + * Special vmas that are non-mergeable, non-mlock()able.
>   */
>
>  #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
> --
> 2.48.1
>

--
Cheers, Lorenzo

