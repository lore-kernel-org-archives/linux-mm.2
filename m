Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2601FF41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336E76B0005; Mon,  9 Mar 2026 11:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5396B0089; Mon,  9 Mar 2026 11:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC7D6B008A; Mon,  9 Mar 2026 11:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09E016B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:45:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B785CC0AE6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:45:14 +0000 (UTC)
X-FDA: 84526948548.13.03FC832
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id DDD23180006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:45:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Coc33InE;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
	b=fhhwhowYxbtXoH/8tYFFVsVVH9xIuZ9FZTW3OGQXtCEj+YU/l4OaJ2+yuttILGl8Ttj5nb
	RTbrXiLBfZqaMyAtH/uIG/VsQhDYvhmEk+kRo/FYCldwOj2thZUrTxUi4Ri4wFB5OO8Ke+
	E3UUMoDW/3Ri1gY2zThxAjCraFo8+9w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773071112; a=rsa-sha256;
	cv=pass;
	b=lOPyCVSlYRvKw7+jzhlxIb6L9i390USg4N94FEhzOU2TAa59AvId2b6kUtOmeuhiatYJ35
	ZlFhyaCaamvA771xVl90I9Bdi18W+fdy6FEPzjF8cm7Yk7jmKeR8WJ14YTVfoDUuL/q+uz
	EsWmf2YavFyBCM3X4Ljw+xmj+OcTW3w=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Coc33InE;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-56b16428b77so1857150e0c.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773071112; cv=none;
        d=google.com; s=arc-20240605;
        b=RhAuH88ct9IYRodw+AquR8h/tFypzw9XWr2Ns2I7g/VaNAHETn/PScrSX9TLnfkOeF
         o8iIl8F142cLSE0ciaPK9gaQ6wt7gUP7o9cSFblZQkTb+5NJe5Wo7Zl6kMyPw20Lw9Lh
         pY1xH3YH9lYMfJr2IAd/5cui9axjGpq/W77IDS8biNFvEcSTSsyixawOAD4sua77ZSHE
         mV4RWgkBVtEqKIi9FAzdbB0TkMR8O6MRUFxFPjs9Mnvi78Ktl0XFZXzewKJ2O33ZZ2v+
         v2/iMhO2tscQaudJ72nYc0d7KEuV1tNCyb7nV3ttKCB6TllvhPWdw+B38uh8MbSWpvJt
         FOgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        fh=4XpKjuYPuSizvvIOOUEMyH0RL33LyYrg1qjnAj+uh6E=;
        b=LOk26Bvf6HZfTvkLr+vbgbRuoIE16Htjk3ydkdksnHwKOLdBtjgGt4EEhzuYin+gkr
         8Dy7sBx0/tmi7JL091u9GA2PkqWUJ/UW0IOazr5ELAhRtC0gOx7Rnwmoq4jpyIJzz/+j
         oMKYJNWzewvm9VdjIYCGNx0eHQlofoBFKlq/Dh6Mu43436daX6VpwCEcMpa9jogjgcEI
         vrpB6O0yVtLXpU6xpjAKHaQlMs0ocyFJFxqdRgrJMSk03clYypWwps4hH9Kr2WFJyerk
         ELfKJk+J579QVH8o8l1RvQAnrtINET+QVEWxzfOLwhSbrZvPXs/r++qUHLoOuQ1+9LTr
         30/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773071112; x=1773675912; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        b=Coc33InEs5S+auniRolcZny1PuSXKXmZT0m6FaRugFnO13/3ZqMUH0pW7DxdbRLr2f
         S//wJWEBR1bx6+v5vU8c1aGeS8nfgSZFqC/9fP/OxYgXdLN4E062lSOxNZXiw6XlCZjv
         p2gKE+ibFEhdaqQY/LhwMOhw6Zm9aoSRV2M6uuOCFbjG4RH97t8Twyn4YyCZmW4Rsu3k
         lQ9Ts9nsqXTKXx+CDxt3hiZmHnuUHmmTl9aDrbebls9GlZacHHf/x6puuShc8UE072jq
         3RhxtIcX8mt/wRwYmI8z3HMJ9/95qvLDOPUsJwP30EvbqcXhtZnWVHJPTQiR5ppFfte+
         sDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071112; x=1773675912;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        b=DbQ94T+3JnbMoGHWHeeE6rSVH1aANMQhVuVev9WrBWlja8OjPjS3/BPRTRjM9dMyQC
         wV6X6CeMI7QItvqSSJuQ7Ce4lt8rIaFyrrrVrZ3OzyeSRFt+v/SEJNtLjr5H36D7CM+d
         aBWmmipABKxyBK7p5b2Qe8n7lTwK1BGnveYT822SBDFnqNFFQx6+4zk9FemtACy67N0H
         R+Bw8ClvbUWQ4Xnh+mus5/jcWqEVqN2nY2I571CeQ4cWeBaD9ZuQhAnAMOZBNGi5NZU+
         s4lyF9NMLql6uJJjFpPzv1Y7YaZqDUVzRrA6oqPzNmqWsIm9+opsAB1NvIBFsiFwcDJ+
         PzjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcqiNpw6suFqTSETNGMkBnCS3N+fAHyK4uOnubAbM+XM46IMDM6aLpks7E/ZohkgPDVKa3KINDDg==@kvack.org
X-Gm-Message-State: AOJu0Yy70fS668K2tSnJ38aXzDinRN+w1pLp2CbUEe4jq0wAu3aGR/9R
	yad/XGcZeUR6QcdTVLnTGsirX1ozDecXMXcTkCDoKsjrinuuvH1MlbNXGPn403/GyNhFcWL+8y8
	2VR8EfFsSV8r4Ls3sTYXmeHC1AoYy7D2oTOVUYtZp
X-Gm-Gg: ATEYQzzw85sY6XdWvieCLBqGEsqfbdQvGHFtq47bj9ufQo5H1MEsemagkWuZY4FM62X
	wL5Rb5CehS3da9fkwfqbYnUQ8fFVGyJfjbltDGpQ1fajITZxLbu4ra4X3+QzndqT6KijmjbDete
	pzLF3UifYDFRWdlBG38kdcQBqstv5cdOngbBeAfrcsxko6/XWAreuuR4xy0aYsaD069evyaVv9R
	zd7CNLBwKPCf7HXYcPlhIDSPedVj4L7z8DSoUmAt+5Jb6CODtawdg1aEVgdsHJZ8fggP/bo3Ifh
	p/No3L4ML2syllIq7nzUFBEB68oxTfe2X78uy4HM4A==
X-Received: by 2002:a05:6102:ccf:b0:600:131f:b68a with SMTP id
 ada2fe7eead31-600131fe1bemr2252059137.23.1773071109964; Mon, 09 Mar 2026
 08:45:09 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 08:45:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 08:45:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <577c4725-7eda-4693-a55a-413572541161@kernel.org>
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com> <577c4725-7eda-4693-a55a-413572541161@kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 08:45:09 -0700
X-Gm-Features: AaiRm50NI2W_b1s4wqVK3z2E19_F4wrYli0WrzITukeFFAKkCo-7bYk8Lb2_YMI
Message-ID: <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DDD23180006
X-Stat-Signature: ubmres8mdwhrme41yge4bi56xwdw3hsz
X-Rspam-User: 
X-HE-Tag: 1773071112-510766
X-HE-Meta: U2FsdGVkX193ISmrdLDfgLugfCk6dDi4sMpfvSpPc0CNWv0CDqmORjrqxsdcAhbrt1Gffse30CK9z5pBzQGMOWbZiEinddf/fC8V8jfdQGMYPp8x1hI6a9soJzSWRyISxKXhxLoJkjEb+OFgKY6XNiP0J4Uf7gD7NYYwzAVu2sNTnfkAR2R33c74sbBq0icMRMPfjVU22sZQPDQ+Z5vCZbpYsjDKVBq8JyhHBHpn5Hq8/gP6chTPpgMs+Q/P8lJv/LpnlcJt5cpLGaV8BPikTeu4OpVU7+4roEWEcjck8P3QHVm0JWSUt4pXoQhLGq2Ar9MrxxBw2MPy2Z68H/kiEYTejd2an89GmcpKQsg3Zgkw/0M+bxQDzo9gntZ3t1/3wTP6I+XNqRUL3gKLpRM6eHMNuL9fDSRwLAv5BO5cnLHfjy/qLzdA0s/4KP+oekZdLSGKS5vLPF38kQ08k3u5fmb8xVvccfMIFsznjA4rQKVcEv//pNPYjWf1qQlg/RDmybSFLDEABpqYaq8jSpBYoFPQda9m0fIb6TQiQkLE+2pFp7vd552rliuM8+uOzd05SHC3TBE/tcy/XBJYnbshiogsJpcc6190JxwJrGA3HV3Y+UDIKcNDUa/PzXcA47Z8bGV0oS2qN3k8HOuMoP6WTpUlCcN+N2k5Hde94ADQ69BXA3kumqWqwyq36FJIzoqRmFD2+7TfINy6Z43qsa+p+o8Gn8H8VJrSIWDKKZjZW8qk9O4JX9k+px2K6A8VsgdbaEiM4tIJYMsGNofBimH23GCiqw8eks3zvdeVhVeIoyEXoq0aD0aMriWvUrP4QpwExr+YDCrDgX2F/g/3c2SfQtMN40cT07+tKs9Gf2sfeVXpktQFErEo0yxJCIg2VNozLVr+7BAD0iQOuN7so+CEwuyZ7cJdwuuQAchnDSZSqqO6LK/5kQIpCh/N69xA7Lhz0Avg1qadpoBCkhSXQdU
 Ff919Oq2
 LEPDvrsoi/l93Th9r3AOsI+bwEH+Zl93ypTGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 3/9/26 10:53, Ackerley Tng wrote:
>> The guest memfd currently does not update the inode's i_blocks and i_bytes
>> count when memory is allocated or freed. Hence, st_blocks returned from
>> fstat() is always 0.
>>
>> Introduce byte accounting for guest memfd inodes.  When a new folio is
>> added to the filemap, add the folio's size.  Use the .invalidate_folio()
>> callback to subtract the folio's size from inode fields when folios are
>> truncated and removed from the filemap.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 462c5c5cb602a..77219551056a7 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>>  					 mapping_gfp_mask(inode->i_mapping), policy);
>>  	mpol_cond_put(policy);
>>
>> +	if (!IS_ERR(folio))
>> +		inode_add_bytes(inode, folio_size(folio));
>> +
>
> Can't we have two concurrent calls to __filemap_get_folio_mpol(), and we
> don't really know whether our call allocated the folio or simply found
> one (the other caller allocated) in the pagecache?
>

Ah that is true. Two threads can get past filemap_lock_folio(), then get
to __filemap_get_folio_mpol(), and then thread 1 will return from
__filemap_get_folio_mpol() with an allocated folio while thread 2
returns with the folio allocated by thread 1. Both threads would end up
incrementing the number of bytes in the inode.

Sean, Vlastimil, is this a good argument for open coding, like in RFC v2
[1]? So that guest_memfd can do inode_add_bytes() specifically when the
folio is added to the filemap.

An alternative I can think of is to add a callback that is called from
within __filemap_add_folio(). Would that be preferred?

[1] https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com/

> --
> Cheers,
>
> David

