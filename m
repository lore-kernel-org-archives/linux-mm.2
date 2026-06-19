Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2644ACD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79D86B0088; Fri, 19 Jun 2026 06:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2AD36B008A; Fri, 19 Jun 2026 06:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3426B008C; Fri, 19 Jun 2026 06:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8DA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:46:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD21D8DA47
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:46:47 +0000 (UTC)
X-FDA: 84896334054.25.E04A753
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0382A1C000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:46:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZP5GNWVZ;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqVqdR7eGLFAsCQYmX5JI1ornwlzeYgCHzhYfEkLeRM=;
	b=tZZQ4InZFVT3zAVJp5xOUeZnt5rEQq6jbt2nXNvn4YNVWe7Rvvz5lRiX2fa0g6sJTKPV8R
	J3U+hTkWDFs7pJb2ZNn8b+qJR8wqRG68rzi/zX+8KkVfe1ytGOrQUj/0N4JXR4v3tHk+4H
	GTZqZLRQR9B6nwkPMguRYlj0lhXbmRg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZP5GNWVZ;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781866006;
	b=smUS2S5Xko+XK8WDgD2/5Ogc3qXGt7iM6yeapp2KPcZ+UswYSgxpN3VBg6imRkj0SNlhHu
	ndfuR1IKydty8DBsKcL5RrVVfwn1fmIotyjKwEgippf8dGWPOXZiAeeCOxxrewrONt7E1d
	oBoPCtfKyS0W5kn7DvUNNG3L3/zQVQw=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177d1ff061so145321cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781866005; cv=none;
        d=google.com; s=arc-20260327;
        b=kkYSNnRfdp4Ga8P8kCK+Js3vPny0tC3B0luk7xY4oaTrs4Uk0i4yu3a9v7ds7TI2ra
         NqtqDANsCAtCDdOWNsm20scWSonqXX6sYCfcSyw9gV0sxGb01L2h+1C+Oo2IaqkSmAJ7
         3fDsVzlLYZly2JkU/nx8hCEU7dJ2HsIW0fPq31ZeTEj0NfuS+6Gfkofv5BU1u+gpJMMf
         fw3xqn7v30BtfzBWVSYkoMQAu3+uHvfvCL47b0hU8+Ar0cYoh7/pOUtQfoEUf9f5wSvt
         Avf/I6OtPVdn1B4L6RxK/kEH6oqriuykn5sEh5bF8F0ziJm9KI/s2V7AG+gmQdCjxm1M
         XqXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tqVqdR7eGLFAsCQYmX5JI1ornwlzeYgCHzhYfEkLeRM=;
        fh=SaLRVQ+DBir/XSZg2hSrNhOfwgZc9UpYHgxVk8ApC0k=;
        b=KWxqARRctyOPrv9XWwUxQhDx2jZUe+HKIZRxUvjugjo2d7fKSHs3MUlhBEcU2srESG
         EHqu598z+mfn0/8521pecuvdXds4vgDh57RxGD3/CIWOTgYkPHDryfrJwT22RQvh5FsN
         6JMYhirLQNeIjIEENNG4+rzeAdP1GjkXMQHoi8L6slNGdr1KATKVvLnJEU+Bn74x96gT
         NiuaSnQEPPKiQVpeShoPK8jn+V39zNPTBR5b0DH9HuMWq1My7/trh+OCtfOmHbHzr6u+
         XHd0omGUp5sQpLM98QBdaUlVFPjjqvAUMRC6poLBPI68Ku2Gr+vHJ667cTSzacIYOq3I
         XIcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781866005; x=1782470805; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tqVqdR7eGLFAsCQYmX5JI1ornwlzeYgCHzhYfEkLeRM=;
        b=ZP5GNWVZPGKntu332yrYTpEH2nJvYDDB1JnvuCsmPwdYmErBKsDZwdgYD7SnqRT+pg
         RDRJTxxWxO0WnWwM+WWpsfa3R0kFh4HmpP8kjMTmPlVqAm5EtP3mH/Eoi5FcoBQ2btEi
         zLdCkW3jwIjatiX22xAnHKrPq7eYBXzEo5fYUauyWxzdnTEQWf/XIxelpEJc2dnZQJ43
         QDxSGO/lub2VHmIOHInXbHa2k/XnDb69LOCDM3JvmAkvw3jq0wJCfSP0JA/cFXNCQJjw
         KIaxByFIlpCZfZC6yE8i7iDhteSyj28XGxa0IYZ/xnBZU4+buNy8iKJbmenKxfE738Dk
         2OJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781866005; x=1782470805;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tqVqdR7eGLFAsCQYmX5JI1ornwlzeYgCHzhYfEkLeRM=;
        b=T/MDrOZ8fUk465fWZuFJ0TPsmxxPIZEHUi5bTajft1NJzo0hiSeqeMNZq0EOCt3TJ2
         RiJDxrsS1bZ1gplsKlNcXVIRHspr+K3sd5TOHEvl33WxUthy58XBYk8/Z/vL0XdwQ02t
         Vg0ubIuBR3AGLgk6kxmtgbei9+eVAVVKtv8D+6m67LitaPqJF1+2j8bjXKWddoUySA2C
         aU4ZSGsayvBQzWoPnq7mEXsC4MPC9hu93QeTY687h3jYz90dGYbBkfU6vi/kSzlYHbmf
         zBiAt7Uw4yJ3nPxHTJeTqMMs7CSu0zqiwGvx7y7oR6STcaB8+zpDSKRBNWH/qp4z6whP
         9yCA==
X-Forwarded-Encrypted: i=1; AFNElJ/1e78alElIID/dijwZkHjDgWVCwbV/TvLOj0zLoS/p504wUaybAl3rhWoqdH4EMrlX6zzLuLEEoA==@kvack.org
X-Gm-Message-State: AOJu0YzfNOArpE1NYM5utKOESCj+sFSjKrdevTHA+dMq+nB0Dkz3clrG
	mlUc0jR98jpHCB4mbJ0hCjh9AQO6niW5pJyT4YDEZqRkF86BFOWtPv3gkSKdT/MFUKx2ChQoOGB
	+VovouE2o2I8KJlLpebbzi8R3Fm3V7yEImSVYkJNP
X-Gm-Gg: AfdE7ck5WEz5HQ2X1rsWpLC3TZq9YjnmPmMV1l60xjINOEtwJ3H1G+ZsjxT9LaWtyGD
	P36Zisr7ofOIK9pX7417lcO1cQM/0uX0ROTShyrhUz0uNs0VyEdMpFLIWSQt43Sz507zbru+VuC
	ej11MBOgYZgYruE3QyX4otyuIiBPcnyUPi10w/ibqtvE9OzmB/TAMW1se0qWljcwViqTQ6tvcMu
	1msPRXT4I/pFoI6tEBAZ+MzbH1WBCe6c5v3K1yq0X3Cfw1HZ1UKQewDTY3yRs0STHtj+kE/KQ==
X-Received: by 2002:a05:622a:1b1d:b0:516:3def:1cf4 with SMTP id
 d75a77b69052e-519e877e8c5mr5598281cf.1.1781866004326; Fri, 19 Jun 2026
 03:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-19-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-19-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 11:46:06 +0100
X-Gm-Features: AVVi8Ccyp37Iml659Lz9n-v90nTTG1Iev3H81NTyrRm5pUpcj70uW3l4zFQ5-a4
Message-ID: <CA+EHjTxr1KrtZDakniWCF+c0E6s9_YbQ_gMVqCFnwEP3USEXXw@mail.gmail.com>
Subject: Re: [PATCH v8 19/46] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0382A1C000A
X-Stat-Signature: pmxn4mqaa8yrkwdiaytxcma8h7y3pjk5
X-HE-Tag: 1781866005-34816
X-HE-Meta: U2FsdGVkX1/n5muykBWmiDR2zvYcAlaFj/ORAFF+sYazPLL4QWBfX3CLG3TMYAey9kXdvHsGSW0oIMRFywgs5s7Mh35Kem+l14V8cgOoH+CLJM61Wg+RDp2wLevQQ8SdEvT+XFssIiSZzcgYXuBGfxjnmriWocue3ZAxwIhYy0GM4PTZRcNtOdDfGUZpeq7KAW9WRmsGnDF6DX29f4j43z27LK4CSsqVXQuIx36KOnln4MZzNqSyX4Is8cr+fjatdb9nTh5U3CiRyBNzcIwBkra2Yo4QVIMKYq4T9H8WquSHyJvSRio3JHXZ/xMVTLOb6O5DOMnwd8Jyhki5FngzjVl4+WUl8pkNLTYAnOokuBkjhd9+iZqps+o9GXDkRy2gWGSS1wnQc9z8i4YsvqbFCwTPCfw9adFOUmYviZlJSJyHSttDDZsGU4Ms/dMp8b6jADIPw4fB5pd53u5Obgk5/FJVO+iiVcK9HitLtpRZdWSfh418D0wJSR8jayblP69oEJBjj8XMJ85nTeulhnvH7s+H+zYqfO6aZx+3/XkYM7TDROV8sRpJLzx0ZXUcCtkTREtAhOJUuLsMPUlz74HRYbL/poYeVO0fA/q2v0KjxiogghqjO3bN82ocPG7EO4SLG0GMfp92ECVPn27kvt/NjkM6idkoBgXfqQMUypO+Xgi9hZRK/cf+ugGrjHSTemx5M4SKv0afxr57vZSFlDzncLtGJUy9qeYSrznVf0D+1WY9sNiuTwo0RD1NmdfgSIGCK2VBTGzv8gYvuGnYpstPaOv42s+5fw17PrnKcTjYlYJlyIBfTvayQ5wjee4bI+VSrVJBGPVzPcmiBEGDZEXKM+UB9Q4SWm0K+yaqFTHjT5BWts2D2mqLngBKlXYcl8pe6ilHC1OUnYpEcGXTnJTCn7YoJsKLf3XL9yMH+cv4pZkgr6hYNlt96fg1S5x57f472TaoIwSh2D8S1fqR75A
 S+m5DlrJ
 2dDuxPOwAajj46ZDt6fGHiIzjX64ZgjscPTc6ZiOvFYjHv+7kljWJfTH1cXLpZk3MXhKuMPGT4TH96WD2EyouvpUn7hI34t4bEEZwg0gx5Lqxf8nNmDqudrMfUu8hFe5D72BOidnnvJsvow9I1HvfqQ9xvkYRywgBKkjAiA98/lEazwafv/BpW3mbfN3bnT006icKBrrFbJUKakjpslZkLSpeB6LVN8+HddcLjWcdHNwcEPRbLLAfINEZlHeOfgI/1GKUpwjwGaKKFRqqvSU9/c6MiHYiKXdEA5cZxy2YdqPH+/hQSJbnbJZ/DoxDHqcxw3An9bKkPJucVjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> __kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
> not specially handle -1ul. -1ul is used as a huge number, which legal
> indices do not exceed, and hence the invalidation works as expected.
>
> Since a later patch is going to make use of the exact range, calculate the
> size of the guest_memfd inode and use it as the end range for invalidating
> SPTEs.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  virt/kvm/guest_memfd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d163559da0235..d72ecbfcc3144 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -366,6 +366,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>
>  static int kvm_gmem_release(struct inode *inode, struct file *file)
>  {
> +       pgoff_t end = i_size_read(inode) >> PAGE_SHIFT;
>         struct gmem_file *f = file->private_data;
>         struct kvm_memory_slot *slot;
>         struct kvm *kvm = f->kvm;
> @@ -396,9 +397,9 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>          * Zap all SPTEs pointed at by this file.  Do not free the backing
>          * memory, as its lifetime is associated with the inode, not the file.
>          */
> -       __kvm_gmem_invalidate_start(f, 0, -1ul,
> +       __kvm_gmem_invalidate_start(f, 0, end,
>                                     kvm_gmem_get_invalidate_filter(inode));
> -       __kvm_gmem_invalidate_end(f, 0, -1ul);
> +       __kvm_gmem_invalidate_end(f, 0, end);
>
>         list_del(&f->entry);
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

