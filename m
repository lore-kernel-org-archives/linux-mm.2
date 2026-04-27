Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E00FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAD76B008A; Mon, 27 Apr 2026 12:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BEE6B008C; Mon, 27 Apr 2026 12:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492106B0092; Mon, 27 Apr 2026 12:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1D36B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:27:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E67CBA0D8B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:19:06 +0000 (UTC)
X-FDA: 84704845092.08.3BFFFC2
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id E80B112000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:19:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pO5kmU47;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777306745; a=rsa-sha256;
	cv=none;
	b=VIYZ4ToTqR6X91upMbKK16sniTx+UV3CSxlnSbrlMYZ+4m+xhgdzd2hwRA/AhMtM3bI/re
	nyXQ4pamPwvU4UEA09ZRw21zpuGCaB4hmEV5kx5rFbafN2/ZH/ksOuGEbylcxCJctZXZEp
	30+Z/rV/ST8ZuIn8KFa/1TsZMsmsC0E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pO5kmU47;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJNjSMzEVnhmJlAn1BmExHidoyff7BzpUCDWj8QBgqY=;
	b=A8tnWq/oJATXQTZkrmGTc45qrE+CJx/roa3HsjU+IU04QZi/N9QLqPjAa07ZrqDqfiG/Aa
	PBMUF2PgYoC3p2mNbu88uVzC0yc8XoppgI2Z+C5Gi35F5CH1FJO2cyGQ7uX1KBeDhC1e/u
	x4XtYbo7HOXQm579pcSNqoqtEr0AZtY=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a40502e63bso9257782e87.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777306743; x=1777911543; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QJNjSMzEVnhmJlAn1BmExHidoyff7BzpUCDWj8QBgqY=;
        b=pO5kmU47XuFkoDXybdd50fhKH5U+LOj6GwvZehaWepUYKCINFblhdwgZbFqi6pQqQt
         T/enGjQhkxkzdiPaIRn7E60vpLM/oo+s/lKfxslczT7f239R3HLyMwVbQidGcpCfQaZJ
         pFPZpilXuhEaJDcJboGVlRaiT88BbHjAMdlZjnCrLpWr5NAGIBPqlXVztual7dXttoZj
         YuHhPTLPBfvTGn2B9+OaWNeRtJelj6/vqdzCsMtIi4BNFTSRgEhpRQHe09R76ZsvDout
         Rg3yrCykv9BCInxRw0EMesMxXdU9ud8SWiXu9JElniAWl4Em1d6VN2qe0+lBkYjukpPX
         sfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777306743; x=1777911543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJNjSMzEVnhmJlAn1BmExHidoyff7BzpUCDWj8QBgqY=;
        b=sITDwAcvPoYbx0LkAQNz+BuYawhCCi5upZRSvOWy1k61KsPaD0YG1O71VrwFSWdEPO
         Bp07H4o9Mgr25VM5tdPi9bfADF8YncCDQGn/59FRq5kkkfmw4u7UYqzOdYjCTc0gD6N5
         zgmE9uHy81DLka+UNWVea5JAAYHzt39LvuOsUoj6yfVOe5VcIWEKINnQ9KVUsXlVJEjb
         iEwaXxd5hl7e5TdJCZMrtWwBiQGP9qtb/yYxcV9MbSOqKoeJ3qM8dd6RhlCS/VnxmKaW
         0tO4zjZXMR+jzj7C6zqBFiZLRVCuq3DNaUnjoTyhS8pyu1zjjQQ8AWGG3riLv2QQhzTJ
         SRvg==
X-Forwarded-Encrypted: i=1; AFNElJ9HYaknGM6c5oyV4hoaIX7yCgWb2zb2jeqJKUKLFUrlGgLjPCVzUyH1RmGKLd+T2JvHfeQUNBx8MQ==@kvack.org
X-Gm-Message-State: AOJu0YysLVhWCzD3S/XJU/cCiJ4ephBso9DhfjmLcoVcPcH5D1U8ov0S
	KPq/XYBHKB3cil0VJx814H2jdliBTZMSJJVFYUx5zpeZBhgue9qQOzZD
X-Gm-Gg: AeBDievJRhFBeG2RsTOjNiyxh+YhjfNENgLLhWbIrUUZKMHYk4wh5a1VGRDnO0ckB7q
	szLsav+v75DIlVCQ6W4zROyXE+67xU+aAjZd84p4+CiXpiN6M9BLvEIH8LyVcFk/RUGzpo6fgwh
	OmutTlOtsCx7oof7KEYI32RW4as9wn8vsivFGGBSjyScLO/skbsLHreXbbV7UbXy/JiZbD8EFR1
	jYCTUuCQTTgx2agq+bxaUx0aEmmynaenSt8Pjz82FGVkZqadGEGvQZDVacURMlfkuBrjN1zSRpq
	CXRCK5Zp+4JWdY83ZLrCzvDZJ6bNDX5+rmcpoXYvoFss2bPka+JTRF7TxYYTFNzQbCDQWSuqYsJ
	JJ+gPueVketEbTI9KuBKt3IUsp7Y1oI7a3tyNH0fqzXkfrMu3ulZZC1WH1uv2i2ASvkJeztuDWj
	8=
X-Received: by 2002:a05:6512:1256:b0:5a3:ff77:aa05 with SMTP id 2adb3069b0e04-5a4172c33demr15446017e87.11.1777306742548;
        Mon, 27 Apr 2026 09:19:02 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185bc361sm8293981e87.32.2026.04.27.09.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 09:19:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 27 Apr 2026 18:19:00 +0200
To: Vlastimil Babka <vbabka@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <ae-MdIOcSkfphbHM@milan>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
 <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
 <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
 <ae9wFZp7dS8QF8br@milan>
 <6cae0418-eabe-4864-b87f-b1f953de06b0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cae0418-eabe-4864-b87f-b1f953de06b0@suse.com>
X-Stat-Signature: sbya1hcto7zknit461fn85ahrirzoz7b
X-Rspam-User: 
X-Rspamd-Queue-Id: E80B112000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777306744-87983
X-HE-Meta: U2FsdGVkX18myTi6KyjKTTTvYfEle8yReckV/6HOoNWua6v5IAHYRjCP/qsWI1qgaZ+9SvuerHaJC9Jp0hlmF0r1JdHAhV3mRcRkm+a09q+YJdD16GrAvBDjPrywEqTVHZbRyWaAlrCeNGsAVk6UjaYMleIvSyI8ICaPowpS8AQ5Qus1dI8Yi0r6/Z2GLPVIzhVeQwfxkP8sVJ0u0ihb7JYHWMYZrqbqqkzzqpYbC+sLdmi9+kAZ6tydro/oZHJwUHFWpVPWp5QKYEEs+BE2ML1JVX89Dizyzt3Rgsi23srBSWqLn2YmmFKEMoGkSeLYRvaLDjlcS9Ysgez8RUkRMcpGYuvpUeWfZnA3VldFe30ftsMBaVpXbU6ECpP2zfQj/USG3F/cF7yUmGH93425NVFsQcXcOcExXPgt1X9b5CJgNdZ9b2xaHen1zO3CndiujrSntmBA4jTdBxbc6Nxf8pAOYPG6zvjKHb5sBgeRvDkMG9zP4Cl+/RDJbSDTTJH+v3BLMh+gEBHqrSI7UM1MiTuSV/Df9E3zGnsFe2TQNvv1To8FcKXx60iUSIaMqztyhO8g8ct+DwzAilcmNdh0krxplCf31mzI1SCxYZNg1jYu8xndETVIdlcERAiXJO3bIuGBIZ/Cry6f41iRD/o3v6dSMcAy0c1kRRVqRRFcNp7/6QdCd/IJVFq7RqLHkwKYLUCRxkNnfaDOTR8UANasWEXEwIUzeH/kDYY94FtZ2hltRngVmoZcIdPnfrv4E2Nc/QiTwWNXwpYO4+hXVoveBUAajn8f+OtrXKa0Omk1HKBzXNeBZvqpHmGVM6DFjvm+gIoJIHMFi9uEbxi4Mioien79imik2djo+0t88r/vtogKlGvUW6eeBvNM07fcoFZtlaGuh7nIK8fEnE1c/GBkB+tUG8GKAI/ssufzF5CWZ18Wo2KMJ0cUphN21f2CpFuVXLeOjVg2k72eXCE65bg
 CDbzTt2t
 9QcHNk8hKPcBnUV7Kw/DtibeXCOeTGBN3OwLTiHWB90BdJ+Qp8ZqJTeblg4lXLc4+g547Wf+jad7a3ESOb5GY+woNbnDPjHOhuNkRO49lEuUhzL3SetJpmhLbaBm7TRGyqe9yKFTBsMJnJcnfPW4sRB1kpIXPMpx3flDEJE52U40gq8EcO1vuVrH3bwLatmEcbSWFFRpIDWZRL6QFNFJTygolmUI2LjNb5bpPR+c19EZdNaM04J+TibHt5ly4mZT9ehe2ZZCEuiDjV8ZWsntGiZqfOSn2xYjKGGVRQuAu/Wn7PV0Lg6DWulF5sDDuAJAvbd5YTHCb4DE/BhuZC3nPXEsjUxysWZiVwmAcrPJK+mW9mpAOyb0z38DN4gyVrhUDpJ9RGsfeTwznLXZfnGQeZU0NxdwVKNVUr8j3cQzcPrIffvyo9CxpIxw/ic8nO39aAOMun91ubr6PYVLFeC483ZYcFsv4KEJW+l67FMrFJqXQQZHCi0wjWHVqs8M5ubzsX6U3lg4wmnt2ng4xQpFsC4LdbHHTx0o4rfMhTxjOrQoweBwIVb8N1shMm3pavOFXQ64dfvFP7wWYO1PedoVgUC/BA+ZBhDzz9nMwBAcVKbK358J4BQfvVfJVic9/Ds+Yl2E4UgYKieofY0N8hJZhVIobJPSQqL4M++zxRYAelVAXHUR4lisR4kCGcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 04:37:11PM +0200, Vlastimil Babka wrote:
> On 4/27/26 16:17, Uladzislau Rezki wrote:
> > On Mon, Apr 27, 2026 at 10:53:52AM +0200, Vlastimil Babka wrote:
> >> On 4/23/26 05:34, Herbert Xu wrote:
> >> > On Wed, Apr 22, 2026 at 10:32:16AM +0200, Uladzislau Rezki wrote:
> >> >>
> >> >> We have added non-sleeping flags for vmalloc() to extend kvmalloc()
> >> >> functionality as folk need those.
> >> >>  
> >> >> Another option, would be: always use vfree_atomic() from the kvfree()
> >> >> path.
> >> >>  
> >> >> Any thoughts?
> >> > 
> >> > Perhaps add a kvfree_atomic that just calls vfree_atomic?
> >> 
> >> kvfree()'s comment says
> >> 
> >> " * Context: Either preemptible task context or not-NMI interrupt."
> >> 
> > I am not sure the description clearly reflects the intended usage.
> > To me it sounds like all contexts but excluding NMI.
> 
> Agree it's not clear, my immediate reaction was the same and took me a bit
> to understand.
> 
> > For example, calling this under spin_lock() will be invalid, as
> > the vfree() path may invoke cond_resched().
> 
> Yeah, it's covered by the "preemptible" word, but not super clear.
> IIUC it all boils down to this in vfree():
> 
> 
>         if (unlikely(in_interrupt())) {
>                 vfree_atomic(addr);
>                 return;
>         }
> 
> Which can do the right thing in an interrupt, but obviously cannot
> automatically recognize the "under spin_lock()" situation.
> 
> So I don't think we can change it now with all the existing callers, but if
> a better wording exists, we could make the comment more clear.
> 
> >> so this is neither. It might be ok then to create kvfree_atomic(). Always
> >> using vfree_atomic() from kvfree() might be wasteful.
> >> 
> >> > For rhashtable it really makes no difference either way.  But it
> >> > would eliminate the unsightly call to is_vmalloc_addr in rhashtable.
> >> > 
> > Seems atomic version makes sense here:
> > 
> > <snip>
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 15a60b501b95..2b5ab488e96b 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -1234,6 +1234,9 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
> >  extern void kvfree(const void *addr);
> >  DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
> >  
> > +extern void kvfree_atomic(const void *addr);
> > +DEFINE_FREE(kvfree_atomic, void *, if (!IS_ERR_OR_NULL(_T)) kvfree_atomic(_T))
> > +
> >  extern void kvfree_sensitive(const void *addr, size_t len);
> >  
> >  unsigned int kmem_cache_size(struct kmem_cache *s);
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 2b2d33cc735c..e25a0eab6ff7 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6802,6 +6802,22 @@ void kvfree(const void *addr)
> >  }
> >  EXPORT_SYMBOL(kvfree);
> >  
> > +/**
> > + * kvfree_atomic() - Free memory.
> > + * @addr: Pointer to allocated memory.
> > + *
> > + * Same as kvfree(), but safe to use in atomic contexts.
> > + * Must not be called from NMI context.
> > + */
> > +void kvfree_atomic(const void *addr)
> > +{
> > +	if (is_vmalloc_addr(addr))
> > +		vfree_atomic(addr);
> > +	else
> > +		kfree(addr);
> > +}
> > +EXPORT_SYMBOL(kvfree_atomic);
> > +
> >  /**
> >   * kvfree_sensitive - Free a data object containing sensitive information.
> >   * @addr: address of the data object to be freed.
> > <snip>
> > 
> > I can post it if no objections.
> 
> LGTM but also should be now used in rhashtable_try_insert() I think?
> 

Like below:

rhashtable_try_insert()
  rhashtable_insert_rehash()
    bucket_table_free_atomic(new_tbl);

the patch for rhashtable.c can look like:

<snip>
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..4111aab8cee4 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -114,6 +114,14 @@ static void bucket_table_free(const struct bucket_table *tbl)
 	kvfree(tbl);
 }
 
+static void bucket_table_free_atomic(const struct bucket_table *tbl)
+{
+	if (tbl->nest)
+		nested_bucket_table_free(tbl);
+
+	kvfree_atomic(tbl);
+}
+
 static void bucket_table_free_rcu(struct rcu_head *head)
 {
 	bucket_table_free(container_of(head, struct bucket_table, rcu));
@@ -473,7 +481,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 
 	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
 	if (err) {
-		bucket_table_free(new_tbl);
+		bucket_table_free_atomic(new_tbl);
 		if (err == -EEXIST)
 			err = 0;
 	} else
<snip>

--
Uladzislau Rezki

