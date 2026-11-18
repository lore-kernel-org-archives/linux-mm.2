Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54639606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bAao3yuS
Received: by kanga.kvack.org (Postfix)
	id 6722D6B05B6; Tue, 17 Nov 2026 21:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6230C6B05B7; Tue, 17 Nov 2026 21:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514686B05B8; Tue, 17 Nov 2026 21:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297F96B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:17:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A03312062D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:17:52 +0000 (UTC)
X-FDA: 85446629184.28.797C4CC
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 890B9180003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:17:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bAao3yuS;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=za7hVhqCXuZnylgObAS3b8lRUZxmuRElCIY9CGv7ZSI=;
	b=K+zl72DWf/ZmqP00AfGVuWuNN6V4J/FIcaYSVqAxd5+8Z9TfHF3Kh6pPO2qfVvf89U2pMX
	fH+QczHmzKWM58llb7kR2Z2Baw3sHuVBDLK7tvwu9SnAarQOC9woztPGkTvQ0+qc9tFpqT
	XPs//TLwEUlknRwh7WFHHIbH3+0H7XI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968270;
	b=j+/uC0Bvr/4TsPLlbX8lWDbq42HIw8WRmqIx2lY7fcB8JRF4ufuWuZ+Tof1PQSKIy4XXC3
	9UNNpjojBScuhM3I/25HwEBf+zz0dCIPNMwPJ3+tlYvJBVzoCuD45R7AzEJUh8zrqdW3v1
	fN0O3Q3dltF75WvFNm6dk2Skhehxytg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bAao3yuS;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b3b4944abeso458335c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794968269; x=1795573069; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=za7hVhqCXuZnylgObAS3b8lRUZxmuRElCIY9CGv7ZSI=;
        b=bAao3yuSohgRSCnH3Zza5g2TuE1/MJdnZukDbr3Dv2J2M5OzKhNmO4+q3NRzIDf4K4
         dDR5ZA9HoNgh3Fu5c0+dMAFD83LWJ1z0H+WDqEke195MbqnJiOgcLy4s969ne+yWJcu4
         kL8ow9hVF6Ui5F2SRiL0fQ0Z+U9qlcsjTFGZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794968269; x=1795573069;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=za7hVhqCXuZnylgObAS3b8lRUZxmuRElCIY9CGv7ZSI=;
        b=OmxB5h3wghvEpXuSohaiO5n/1+a3MdQTi0wtSKzcKzaLO5qtdHMLRcI1lGh0PynRGE
         IH0KJUJo3V19vwPq7xiUPiY65ZJeJSfF3QziMa98WB18g+L32uza0AqlqJUU37+bQ3It
         tl/f9IXDwgzdKcGzwwb/zoOCO1mkyunQPuolCY/08enJ/4WfNHNHRe1voRMRI0DR8W0e
         qGD3mKgsXnN/hcmJd3ZqQW4Daf1P2RIUruZtyeiiwbNV+fXqfH4lpHlXH5GuGh/XzrHH
         VZtYu8rk6bsZPUo7Vq17aDRojKbgumb8NsnWb9qJb+YtBrS66ccrs/aZxk2qT/iCRLSr
         4zkw==
X-Forwarded-Encrypted: i=1; AL+hErHNG9Y2KM5wpIUl4lmVpFAid2UesL6HiDoCHGLWV0L5RiEViCSxul8iPKtXUcL33A8IjZqgPF6JIQ==@kvack.org
X-Gm-Message-State: APuU4Z+u1+j4uI5ldYrJZQ5N4NilHv74dPpu3yLUIGsvezpWfUEWOnFZ
	Y5aZyZI2wiExN2QaO9ao/r0jBFsLWNqudw5i1s/Egx9bcQDXRLY5Y8f0BhZLw4m3Ew==
X-Gm-Gg: AYBFou3Ypo25a4uiZ8DPFMm+9dZjQKTBz9GOTsNxk/PMYG5cGieYnt+c+97Df2nzOPB
	Q3tEreiXuc50Qekqa2XebuhAfGPOlbpib7gkCSXRWp5Gk4QCjCNNKh56Ykg523Y5mcremjaeVkE
	ggb248PuKOz5l+lZstNwKLR/K7GWYengggiKRafGe5utifRiiGlyF1WiYqZpgHaedzA1TQTW0/H
	O8nJv+DHHVvwmxWjMZ3IbD35exWyzAK9f9heOw8hcxMjzDOiNd7ZE3TtdJtkChhPmwRvm0Bi7Yl
	M2tRk2Y2G6bmrCzV/3sUy/BCvCR0bzGUUwzhNt2I9m0/vX9k2hczfCAhkOZkKHo9C28EFHKs6T9
	yW0DN0m08z3+t4BTzhbjjr3g+LYbTXkNr044FGSwMtXvRnpo1i51JZssFULqLjHwtBoPoG04e0i
	radG3X3sB4+Ydr6ssiCGSeDx4S+5tnqJxkhjHFbOAAdEQnmlDSOKwj/scbeAXZMf6qXZTNL7frV
	riRAktkadY4NSdWlROCQoDDivwNlNhaGxZqllmYb/loVFg8qj9R7ik5+Hsarmu9NYgMQCwBSkLW
	HZn+kON2KXfY+PZqtWAhv7zWRaEysklqXJx/+KmBL36mmqUUINa7q2gq4D4HJHSYiQL7iA==
X-Received: by 2002:a05:701b:2097:10b0:1b5:281e:1702 with SMTP id a92af1059eb24-1b543d270d7mr1285759c88.41.1794968269079;
        Tue, 17 Nov 2026 18:17:49 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:cdce:1079:e29c:bb93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a7eaf3b3sm2155994eec.27.2026.11.17.18.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 18:17:48 -0800 (PST)
Date: Wed, 18 Nov 2026 11:17:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new v2 4/5] mm/zsmalloc: remove unused zpdesc_lock()
Message-ID: <av0KlWcq9TgxiSoT@google.com>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 890B9180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mgsk7k13irb3td1ed91cjmoi5iem7psw
X-Rspam-User: 
X-HE-Tag: 1794968270-721217
X-HE-Meta: U2FsdGVkX1/9FRH7luurKtqJWMuIaMA85zgcTky0CaloVzZWTMepgMfWCHCtj+uquUY1oGbqMR/rIZwgHBq9gW6gGAyReDzZWrFhkopCuBhK/4tB3CoNwaxiMbj06QU+HZogAf+fgTZkYChizLlsErV03+S5cPeY4JlzooNCB2c+Zftx6t4bjrGXQaMf0qVA5J8yDFeoiTQV0Npa2BMThIe5ywOlMmgXWtPE8Ia3NQ4RxylDvfhfAx71byHzX49gwX9rhj4ODf7y4ZgJnFrFzVGCxhR/FbHFCUuTncGnyHcDiERVJMQF1q59U/npoCTP+VjnEF0vfMTqzjkP5kUF6J0uqwh2BRdZx4ZpWJO9dFmEYBg9DTW6MQB8N0oLwdsuJKkBO5tqQUa+K0B2YbuZ+M87Ahfo0UP63Jpg6lIucT1gKl0A1XH1cw/Kw3m1YskHTbjX+Yb/B5G/VfXVxKC93wdfttl06HihpXKRr/tkbU0PR1b7+HNOiqlEtfFkQC0EqjrOBvn6SyhzEgisZOlXbb7sxZcNZdDTQnLbp2awtQwPsfwXG455AcGGquWQAUlZrJKlJvmUg1U1/m/Fvro+iS9SW8zhMSytzdJnaFSe2+n+jKu3M5lFnsbRkrYCOlb9YqNhgHH6f3TK0478jsSXV/9YzZwwAVU/OZDKUuIxEEukLl1SzMR+XjHfOlpOB+2qWhtydaqkS/bbh6uqBL0ePjaFQDLsGrCSN1uSt75eGzhmpQqDFtK80INYiK95CQMtKkJr1lKOIA2/OOQaxOpMlPdXkbwiJS+u9XIXczdAUoGCY3j7YEQZz9AwqrxgoV0eSviSm7AUTrA66Y6yJvdDKHaV7Ubg8jqDzBssd/YuzAnfUZs4qcSnq3/OSqSI294SnUHpz88LG8rlsySU6Xk29ZHNDJ7wKgerDziOyHHCaGoDcseQdCxVPilj9RgQiLCRgnpjqUVcE3826puCrmz
 5ckMt/WV
 VRDt0AYEB79REKTkyovn3B0XjKlOXnELFk2u0SHi5ovznx5Jumas3gP/JyFDsMo8rNZWvH2auH9GqGQkYy/+4WZ59K9cj9wl909iN5UCNvmRT1BMwzSgmUf/jQl5o/dyu89D1Hv/OuZ3uorVMjblcMc8xJqfp/vJczvLOJ92wo4u8Klf2LBH3EsGiiUIEWCS7au2paxo5HTDsW84qDjGCIgDcZZ1bUnAyyw49SwlgmSzohvn173WdRKA8hA7IKIuCO0IZqZHr4VpFkIEGUSU0SePnypxeeBRFg+IoIfXPh+XZ3y2d+VSkXXOHvStc/gWyGAXysvAVg/u7IVDS5iIBjMEYLqUph275Z/KsGOSRKLsDS2xbW7CCDaXo0mULJEvPkoUE290zPXSg8F1f0ShczAk+wAZ4QTP+HSHbwlQNYOmHGA/sBXjpCho8jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/17 07:16), Shivank Garg wrote:
> It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
> trylock_zspage()/lock_zspage()") but has never had a caller.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

