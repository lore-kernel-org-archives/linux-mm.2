Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE067C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF526B010F; Tue,  1 Sep 2026 05:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0BD6B0110; Tue,  1 Sep 2026 05:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A693E6B0111; Tue,  1 Sep 2026 05:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 864496B010F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:45:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83C7FA0311
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:45:23 +0000 (UTC)
X-FDA: 85164710526.07.C678C2B
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20592140003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:45:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLfmazoU;
	spf=pass (imf09.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788255921;
	b=NVJcNgTVVxjV9edioOT+HOXwoiyqIfBL0szrQ1WPOfWlOOcicDVvob6i2abToqxVdDaW74
	0JCE3JQXi3elngkP/4BaLuLcKV4JPyXPxQZooq037mkhlZclL/z1JLTUEL8ejqbcRZfGGM
	4aDXmxeRqSpnpWdPwBovtYdv+l2FExk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788255921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1Q1LKo/g/Z6nuWp9yOiMW/hGphYqFGaluSO6CBA0Oc=;
	b=utFIKRRN2gKxvrckfUP2CSnXLAKLde5E2dR/qRIRgruP8KMLTjNUHHnILocWNT53w7+HBE
	AFzn+6YQlg2CQmoZJ27BBS2Wx/cD3DSLsDoZuIhEJ/JpAiInbIWI9tp6vEwsj64fwjhYzP
	k3BctApcciWuuts4ITaK/NwOjhJZGOk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLfmazoU;
	spf=pass (imf09.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z57+bjmdhsIpnXeGD4vSr7O/fAZ82WFkyFGHAzMiiKY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788255919; v=1; x=1788860719;
 b=iLfmazoUOX2cm4HqhB1M5HCeoyTJS32sEVDHr7Qybko3AAfBBq8kgsWRCHAn0He61AGieO11
 iILrnLnUQLqJFlIHAI7hrK34oqwAAEmo43Wb0ozK7IPyjxzRt29v8j0Z9tKw6r4b1g4v6OWun9j
 ORgMYT+hN1aWJ1HN93a9tvoQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3f6f18fedc315f36;
	Tue, 01 Sep 2026 09:45:06 +0000
X-Mizu-Trace-ID: 3f6f18fedc315f36
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a8173142so4108e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 02:45:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBysqWT4twOB1mENz0DVd7C+8b1m6UNd1TARtlSETK6kHG6z0zIyU/OsJ/qBsnXSRtyViyaCEeWKKA==@kvack.org
X-Gm-Message-State: AFuF++kTl2Ar1+v6TSd7SWUcbI2Somixv89X4/tp4wwoGuKCFv1yKr+V
	oYAOtiY6kGSO+iD/JgC1ghBuEPRClz73yvwl0iZU0+ROfJyRdaKG6LAD707+Co4v+VvQmcBDy8/
	DSU+5jhBBD24obO8noOKCU9SOXqGjKI86BFcdqsJQ
X-Received: by 2002:ac2:51cd:0:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b5ff233baemr129072e87.4.1788255900753; Tue, 01 Sep 2026
 02:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 10:44:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwWJ71eHG9MKPoHFzpTF_tgptm89F8N3auD-kFhiY9ykQ@mail.gmail.com>
X-Gm-Features: AcwNN1UPfOAVycrEsYSNjlC5T6BZ8Jhw8Z-X2BEumfOk88JPkifl9vaDdwv3ap0
Message-ID: <CA+EHjTwWJ71eHG9MKPoHFzpTF_tgptm89F8N3auD-kFhiY9ykQ@mail.gmail.com>
Subject: Re: [PATCH v12 11/45] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20592140003
X-Stat-Signature: a49nd9e14poy3qg56bgxu9hqxuxi3ygx
X-HE-Tag: 1788255920-929410
X-HE-Meta: U2FsdGVkX1/9pT9wxCFspOxNHKBYii18Ij+bxZrw/YMiKaostxmJ9owIIdOH2mE3b61AzWtYYP3j7GhPeuu5J/ey57x+JvemrE3Fl0+xZa7cOpmE0UTDTfr7xdEzZZDnSdDBjFiXYHLnqWRK2FTKC+UrixWmqgCmBLQ5B+cENj/yqGqsjadmtWM8FZ64azDHn/NNjJxOFGxNB1lSZ04keC78J5M7yUvjnwJmm+0WZdM3e8FSOxKFejmofOLeZMVb0yUzOsTku3/AGzJ4lf2ZDFClOSQRyVcvvfd0hQK464wCGKj/aJ/kuyHaF0Wqazvjg4IDPWnrGNYIOtUfpOmtML/RWM+mnBUR42uquZEE/H5CjyMQDQCOBt8zKHfXOU5IwFwJXKdwqLD2LDjWXV7ioRdQweR2UHU0+gbuTlHdiPR1NAmbCQ/pHSLOL0SRqm0AUfkui036g23LkkCMCdErRHBEmAoNozM7svPnO9H1fg1r97Z35Xjm15FOeo7Z/lX81UjsR1bQvWJRVoSyvJIfjPLNa8cSxNzsvpC3VUnOz8gA5z7ntpWZCAYYc9/vGRJCZAhDPzBIkwdn7ZTwAmAZp7rDVT8ibk3dN9xKB69LnE0vv/CekjroXlsMsQdPoEd/rIDS7gxWt6lbsaroYVrtXqQx5AaaTEQVC9PabkwTKFBNDEGawjvvsNn76tJZ8ZyTNni2rj0bgVFZxsRtpqjF9UPolWT5g76VbO0bHnL24SFagexLiSi+i4XgB4IXZKHtzaxvupgiDRwZuEyfjWgzahi/zhYudxAaOvF8HGEBrmUxmylIud2JrUS8xkNFDcW2UCvRIA/MazQGqEgcYErHrt3UmX4IPiuq2a3it0Eva74XVlNx3718rWk9cnYr7vkAWnuoVet+9P95IgFb65RGtcQfQiZFL6Nuw9mNTW1tuKEofFnks05YPiUK+aMTSU1Dbv4PVCx5nELP9rQW/Zv
 tdhFonF6
 qKD6xOgX31mAAAloSGhd4stgH62F8Yi6Y1ZBFLTrb4iNi5h4hVi67uEAUslqwK0x9eVL2dCvq3e/rIOV5CLdF/oEOQPNORXv2dPwvPAtsufGezteyQKpGddLfk3b5+ZExkYJS8CeeJOtYnAqprCepXLB1OBDAJYeX0gB23JNYCf7oKBOu/bjg0GHUqgk0Wx2rv0SAF3ORDTcxRcsKmjQkhsq7/QOvNpzo93epO5gufCjXFE/m05yStlRNanymSaBCJ9PzPXREHocpgt0J4Vg0KbVaxJg4KuAlRaPJGIpszc9r2UzcnowWf6EOBvrF3jyE0vkHSX0Vd34EY/2163GR/NiTdl/b9u1UxuHCmqFyxvUGSRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> When removing one or more folios from a guest_memfd instance, invalidate
> both SHARED and PRIVATE mappings if in-place conversion is enabled, because
> stating the obvious, KVM needs to ensure that all mappings to the folio(s)
> are dropped.
>
> Opportunistically rename the helper to capture that it returns a filter for
> all gfns in anticipation of zapping only the previous mapping types on
> conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
> mappings need to be zapped (ignoring that KVM would ideally not invalidate
> ranges whose attributes aren't changing in the first place).
>
> Note, precisely zapping only the possible mapping types when in-place
> conversion is disabled is important for functional correctness, not just
> for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
> tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
> incorrectly zap SHARED mappings that have nothing to do with that gmem
> instance (because they're mapped via a VMA, not a gmem fd).
>
> The incorrect over-zapping of SHARED memory that doesn't belong to the gmem
> fd requesting the zapping will be resolved in a later patch, where, if
> in-place conversion is enabled, KVM will use both shared and private memory
> from the guest_memfd. If both shared and private memory are from the
> guest_memfd, invalidation will only zap memory belonging to the given gmem
> instance.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  virt/kvm/guest_memfd.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index cd966eef45b69..0afe1468d2d9d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -139,8 +139,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>         return folio;
>  }
>
> -static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> +static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
>  {
> +       if (gmem_in_place_conversion)
> +               return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
> +
>         if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>                 return KVM_FILTER_SHARED;
>
> @@ -191,11 +194,9 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
>                                       pgoff_t end)
>  {
> -       enum kvm_gfn_range_filter attr_filter;
> +       enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
>         struct gmem_file *f;
>
> -       attr_filter = kvm_gmem_get_invalidate_filter(inode);
> -
>         kvm_gmem_for_each_file(f, inode)
>                 __kvm_gmem_invalidate_start(f, start, end, attr_filter);
>  }
> @@ -347,7 +348,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>          * memory, as its lifetime is associated with the inode, not the file.
>          */
>         __kvm_gmem_invalidate_start(f, 0, -1ul,
> -                                   kvm_gmem_get_invalidate_filter(inode));
> +                                   kvm_gmem_get_all_gfns_filter(inode));
>         __kvm_gmem_invalidate_end(f, 0, -1ul);
>
>         list_del(&f->entry);
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

