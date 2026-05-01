Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D203ECCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CB06B0005; Fri,  1 May 2026 10:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01CF66B008A; Fri,  1 May 2026 10:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DD06B008C; Fri,  1 May 2026 10:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35FE6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:06:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B21A1C1661
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:51:50 +0000 (UTC)
X-FDA: 84718989180.11.DEF4B4B
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3A0E100017
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:51:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhEQk6k4;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of cnrzdr.dev@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=cnrzdr.dev@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777643508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osxTzFwuzlfiSHit/1bTC5t5tDB/OeunbMNG5r2no7o=;
	b=DFtwlhAu693tmQI+rXJIm3mp55Py5BAr1wI1MfSlgEv0vgh6gE3Uyr1o4Sx/ASr+u3dZc6
	W1hRcpHa3JjhOYnjevjX7Ii2BFGw8okC0Gb57ezGyiJUXKMCDp8FB5Qjm0hNIskSDGkYcF
	Y/AyaCK6m2SJl/7TmUAdWJmNcjPC7Ao=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777643508; a=rsa-sha256;
	cv=pass;
	b=FItXCADgidh5qWlMF/PSEb9svN/w9u/i0FrcGoY9XPIhXawMH0qxIAOFIY8gEEhiMQEHq1
	JRUnKgFwmj735AiHYuEySOC9AzvVhlg1gVc1gKiNJC0V0ozCEXmssY/TmkslsJATym6Ou/
	km6lStGgqrF015LoeJ9bR3wsDfGVP0w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhEQk6k4;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of cnrzdr.dev@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=cnrzdr.dev@gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ba51e69988aso310404566b.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 06:51:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777643506; cv=none;
        d=google.com; s=arc-20240605;
        b=ZaLdbx/LMxD+irrtvlYhKm1PWwhSOYOjNioQQwq2f+Qc6yTOoLraarVB6s+d93gp7M
         dbIPl+8RdKa3k6sW4xpnduZkahgh3oxRU3rtt5NWSBA0CW6UzPWFm3n4HHXMXKqGvXRZ
         T7wIHnTo01Xf2K5rVMxizHdCAxwEsTeB1T8IaTjJ3ayq6eQxLaiCuNmuPu5LCVH7rkim
         J6VK0HO2r8t35LIbYBdr1tnzmk2ddMNL6/P9Qp+tY6ONzYDN/arxBrlfOv4hVY7Mpx40
         1GolVoByr9Mn4wc7WQ/ouV1GvUejXvkYT9p8JC1Cdj0GCyMv1LbvjYCZUdHFfgsGR8w5
         U4Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=osxTzFwuzlfiSHit/1bTC5t5tDB/OeunbMNG5r2no7o=;
        fh=1/DDx6cV6QG6QAm1MnKZb+vqN3EercRPhAarq7rIi60=;
        b=JDMY86lle8D4tkNjSVQmusrHvIwZI/e72UYanhRjrENh6TUynSRIDusyD/OJlo5kKw
         pU+5zBxG5iCn8JAJfRajkzWHzV6Sf8K8yrGEw5uU41NsREta6bZ2NneWhX3OtnkXORn/
         ggXe0+fwkbjgGpvsb3MC/C3ZZwk9VH9DGZI/clTUnp5UXXXvC4DNaUv9c1ZRR1MjyBHu
         LiVE5pTfZPfSWitFGFzWG22c0I6L2bRu4lS9f4prGz5nwUSPyWXl9V9ylQ+UJLY9aX9x
         77tTSp+8h80MCVjZb2g9iemRcHGc+d3QiVUroGKS7lKUGxgMzCaiGUmTHM4eb+jjgQEX
         B6Ng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777643506; x=1778248306; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=osxTzFwuzlfiSHit/1bTC5t5tDB/OeunbMNG5r2no7o=;
        b=KhEQk6k4k+DmWhs6I7utDK0KolDBm30ko4KelToB5aECyceZCZxZg8ZYdPxWjg6YDG
         182lPq3YL/aUdC1axPwatWC0bvBCFekLJDxW43JMLoAgsXnH/KjoqbPlSZEJzBi/CEZ1
         1bnwXTnedmvZTR/ILnY6XZ7Tm4QqlK16CNTnDzXUoJwOCgKyfuWbdujYHGsJjN6BMh47
         vlVchd30y0fQFhReXUQnuUFiMH67QnoIVBanKaEBQDzEy4nXanNE1snNYfAwtIp165Aw
         OtnsO2BRuwxF7P69LbbavOMJNxLq+lTYy+1RCjOMhjMaQNAcfQGP/NFxNI9yGQuGF7sH
         nHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777643506; x=1778248306;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osxTzFwuzlfiSHit/1bTC5t5tDB/OeunbMNG5r2no7o=;
        b=syvNBmiZ3xYMkyFH0y1EsrlY6kOIvytrBjKpaBXofvp6lJYwfCZaSHVPYfwdO6gbqN
         fCzg1zyh34cVBMn47GeNJxP9feg3ROdHYcSDCO922AtQ58aPLrGDl6fLFwqBz18UBdcS
         rOcKmHWaaZn15YBAgkkOzCrWR57RpZBXqkChr2p7Ab4v+rmUYnymqiUY0UqAcpKEYZsg
         sjj7zcLmqSG9t4mptHVMybTADwvgvGug+i9GfuQ7P02kSyAxw6OpxQRHX6ZGO8UFnsph
         yw44cjmeRjysI6ScQ9cD6JjLDf6wLU9Xmw9Gvs8xJkB+5jinjn8lqdEpXdO4gAVhfYNA
         zAmA==
X-Forwarded-Encrypted: i=1; AFNElJ8DZTeUND8sfDO5WJhI4pLJ62oulUxVMOq5J2Uf5ptmxUwQsZ7oncwK9J83hcnLCY0zd+O3UZOvIQ==@kvack.org
X-Gm-Message-State: AOJu0Yw050LLWKLUJbggTRVfvp/ZxA/fY9m+y5qXhO0D94/8KvtrH5x1
	U82EIjGz+LdIhoicllnyuu/cY67gsQHeSUMh+MlmI6IpYAIyLqs9KYCBmT19C2JeOJf0ZGLCygE
	jiSXcUjaL2WcegMMQyyyOt+k+QcMsAJU=
X-Gm-Gg: AeBDiesL6IIO/bCcunqX85JeaORxD2jWtoTiwirUfyQucnAa7cK/VQwejCyvLmtsfgy
	9z67Y53YgscArYgBsxlXsG1CJ+Ga7loS1qZuK1s37saxGShe/HGqGiV8QthRp4yPhmQeC48CHG5
	sJTr6W+ujYe6RjOQmlVA8BecrMNAKXFkdZsITT2zyFklYCxDKSwDPTdgoYqK526vSZWQ/bLQ+aR
	CD0/feMJ3uzHB5Voja5SlTJYLPx4TR+pprOkRcsFaUuHDyF7Jx6oRgm5Wk4rrCFhVa6ZDoIf9TR
	4+QfmSz/D8tk97YlxJG0XnTFDz1kWuDI76FZbe90ye9kCDib1XXGeP+qmhhNcFs18PMqjWaGPvz
	b
X-Received: by 2002:a17:907:98a:b0:ba2:65be:2984 with SMTP id
 a640c23a62f3a-bbebf0e4209mr136193566b.19.1777643506084; Fri, 01 May 2026
 06:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAGdYFN3uXA6gqW0yrsCcfx2pY5An0V1PQm1YBL5Zt63RaEAy8g@mail.gmail.com>
 <2026050112-gumming-overcrowd-a945@gregkh> <CAGdYFN1Z9xtOk_VP6OsZ8mcpsw5pZEk0VB_CrtKDk-AxhcuYKg@mail.gmail.com>
 <2026050112-hatchery-tidbit-3420@gregkh>
In-Reply-To: <2026050112-hatchery-tidbit-3420@gregkh>
From: =?UTF-8?Q?Caner_=C3=96ZDERE?= <cnrzdr.dev@gmail.com>
Date: Fri, 1 May 2026 16:51:32 +0300
X-Gm-Features: AVHnY4Law2QHlgxr-_KhBz0NPMNxyD4lzVVI2mAkGAE6ZM_1PDA8uURjK9n1nmY
Message-ID: <CAGdYFN0BdcM_QpsCh4YVD7S=7MeG+AgM63ZuUfaZS2gSUYHqPA@mail.gmail.com>
Subject: [PATCH] mm/bpf_memcontrol.c: fix refcount underflow in bpf_get_root_mem_cgroup
To: security@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	roman.gushchin@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="000000000000b7af800650c1e144"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3A0E100017
X-Stat-Signature: 4qhtgtbxk7wwun7rdb483ft4zinp1ecc
X-Rspam-User: 
X-HE-Tag: 1777643507-880940
X-HE-Meta: U2FsdGVkX19u6SsvfqEZrV+z1dC0eSGrR7aWdDEe9nc6KV8sNnqoNFQejiYnXA2myUcabFDCgCkr3O7YMDfURmHxR9qIQIstxW1WuKVrhgdu1JtfQgICYxV+uDeaMakQ0gpIbZ+moe93+54W1jG1hW89b78HZ+i4qT3zDn1NOftht+IG5i8+PlJa8EI5AJnXO4AK77xwVz4Hwyh/DzvFXx/pYyRA8o3xC4PWhr62mwAAb8Wky81PiUIk+c/y5FhltDaHZT5vw7dr/c0ksAphNAISIRMmcZ/hYsYd6z+ce01vbDMveJGxD5ACNUC7Z+os7MFUGY3YGMqKR+Bb6w0vJ4MbAlbl3jpQh6rrJDAWL/lT+UwdBG+htdP7rVTyTKmlQSravwDhAv9274FKag9EiMf4qo8JLFq3r1L2LrGFPZPgMIuoK1pweDcp7DoW0lHBGzLHERmI34176QCAof8oTdEDd1BfnqByrf/oXhcTH0meCR9PQhib9zLdpDtZW97cjr04jauI+pgtbHxEAH5UMVq+xGNpkppYcfzOGdZzs4ROPpAsWHU7AmtFf9pOL0BCvisOoAz3BfO01fEHmDvDb/j8otHWHKoSK9IRFoLr83peRXxKqAU+4NcmqNyXvL5PPcMRPy+daBCVdnTfQ73t8FD+L77ysEY42ce3kv2RoviykXkXe6v7iiTz4tvSZDTww+vsdOt4FpcVIoaI+J7vGKcPPXLwvSBbzfjYUp3ASncBL1JsI8GtnacypRN+yEfDfYrowYjPCBP+h5UoC/AoWEFH9ccbX+PnH1/WuI5hsKEtZYN4HQ6cfH+nqy/dj2KgyfkGsvEHnCkDXGoEaLxV6Z8aCmZMfma+w7xaytMYXSE0xgRMaH75aemHhwuLLGosxTDIy4ptmPzr4dM/S+rx2hcRN/eIr/vMfndAVDKgBhfI44qXFYCU+WlKmga1I0QvO9FO44Kg6ZsWs3TNP45
 vPZiwv14
 1qME/vhmGYr3TUIEMTulmu+q1asWUIk/VwuhM7ZXngfiBrZ2xFxoNkUlQLJL+Qbp2ae1A7E65xzmlkN88EKl7BBdw+VkEmI5SFvYMVEHvbKzMwpRlDgI5hiwL4OA6ToSn7NkNihrpiP8NuPQTy/XuD6PvCeBEsRMZydaNsDflEjRsx6LaMIMVWlvGP80k8uX5dxG3bb8s3O38KUf7hTCSALwuaWTuZpbc7o+EJYwTbnRGLl5x7jQkbTNPCjzdKRz6xYd8TIYU6sCGv49F1tVFPSOBUZPU7byT5n3BGWGEktl8HbACv/l07KrTNcMdmh3gmQspD6jIwU+FA4ye9aaZqYoW45nRcWdNVfFHewPn7a1mMkJt1/31IdYoilhrY6F3KyraGjpJna803pSRL7cs3vxtjXRw/iTBQgRYfE18fFeqC34ktw6UycmotcqpioIPxdGdgIc34FiXeO4Y+Mmbpei+IZ6hSCg5SMCHzHuXg0FNjtRnCIK2xN/NJx+lk8sgFYiGJbuSTTbPeE8a7dYlfogDzAcyAy7yk0MAZR7ABE1k+DuGiNfps2336g08kf3jim+ojiFhVFpCsks3sK5zTEaIQyY0YMS49paz0gcZDXAFTjAPfeyrkBK6n+qv/TTpmDG1zLilOHYzPVLtMIKXEQXwwBAZJ89IAZg5Ia0SZPX7KfugK1CRTt1ShbQBBOrXrCCNLZlayax1fQYKf9QJMlOW8fSH6SLfyJMHT9qA3PH3URFuvDm6P1HKeHT3UY6P5sLsBxdmiVZU0RLrMaDrIlpptYmYn6W1Z1h8WY+b6AYJzWVxb9xBe9+YymMcAbmYWzCI3QOasYso3VRF32gVPuTT3xeUKjKv7vJlByiUYgwKqG8EkAaUvJoCtC78A4HzLjKRdTpOcivvkVl1slAFmB7rboNUYPAOBwQ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000b7af800650c1e144
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

bpf_get_root_mem_cgroup() is registered with the KF_ACQUIRE flag,
which causes the BPF verifier to enforce a mandatory paired call to
the KF_RELEASE function bpf_put_mem_cgroup(). The release function
unconditionally calls css_put().

However, bpf_get_root_mem_cgroup() returns root_mem_cgroup without
calling css_get(). Every valid BPF program using this kfunc causes a
net css_put() with no matching css_get(), producing a persistent
refcount underflow on root_mem_cgroup->css.

A previous attempt to address this removed the KF_ACQUIRE flag
entirely (commit e463b6de9da1), but that was reverted because losing
reference tracking semantics negatively impacted usability in practice.
The correct fix is to acquire a reference in bpf_get_root_mem_cgroup()
to balance the css_put() in bpf_put_mem_cgroup().

Link: https://lore.kernel.org/bpf/878qdx6yut.fsf@linux.dev/
Fixes: d0f5d4f8f328 ("bpf: Revert "bpf: drop KF_ACQUIRE flag on BPF kfunc
bpf_get_root_mem_cgroup()"")
Signed-off-by: Caner =C3=96ZDERE <cnrzdr.dev@gmail.com>
---
 mm/bpf_memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49..3e8721b 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -25,7 +25,14 @@ __bpf_kfunc struct mem_cgroup
*bpf_get_root_mem_cgroup(void)
        if (mem_cgroup_disabled())
                return NULL;

-       /* css_get() is not needed */
+       /*
+        * BPF verifier enforces a match between this KF_ACQUIRE kfunc
+        * and bpf_put_mem_cgroup() (KF_RELEASE). Since the release
+        * function unconditionally calls css_put(), we must acquire a
+        * reference here to balance it.
+        */
+       css_get(&root_mem_cgroup->css);
+
        return root_mem_cgroup;
 }

--
2.50.1 (Apple Git-155)

Greg KH <gregkh@linuxfoundation.org>, 1 May 2026 Cum, 15:54 tarihinde =C5=
=9Funu
yazd=C4=B1:

> On Fri, May 01, 2026 at 03:40:46PM +0300, Caner =C3=96ZDERE wrote:
> > Hi Greg,
> >
> > Thank you for the quick response.
> >
> > I have since confirmed that the bug is present in v7.0, which was
> > released as a stable kernel on 2026-04-12. The affected file can be
> > verified at:
> >
> >   https://github.com/torvalds/linux/blob/v7.0/mm/bpf_memcontrol.c
>
> Ok, then can you turn your patch into something that can be accepted and
> send it here and cc: the bpf maintainers for their review?
>
> thanks,
>
> greg k-h
>

--000000000000b7af800650c1e144
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">bpf_get_root_mem_cgroup() is registered w=
ith the KF_ACQUIRE flag,<br>which causes the BPF verifier to enforce a mand=
atory paired call to<br>the KF_RELEASE function bpf_put_mem_cgroup(). The r=
elease function<br>unconditionally calls css_put().<br><br>However, bpf_get=
_root_mem_cgroup() returns root_mem_cgroup without<br>calling css_get(). Ev=
ery valid BPF program using this kfunc causes a<br>net css_put() with no ma=
tching css_get(), producing a persistent<br>refcount underflow on root_mem_=
cgroup-&gt;css.<br><br>A previous attempt to address this removed the KF_AC=
QUIRE flag<br>entirely (commit e463b6de9da1), but that was reverted because=
 losing<br>reference tracking semantics negatively impacted usability in pr=
actice.<br>The correct fix is to acquire a reference in bpf_get_root_mem_cg=
roup()<br>to balance the css_put() in bpf_put_mem_cgroup().<br><br>Link: <a=
 href=3D"https://lore.kernel.org/bpf/878qdx6yut.fsf@linux.dev/">https://lor=
e.kernel.org/bpf/878qdx6yut.fsf@linux.dev/</a><br>Fixes: d0f5d4f8f328 (&quo=
t;bpf: Revert &quot;bpf: drop KF_ACQUIRE flag on BPF kfunc bpf_get_root_mem=
_cgroup()&quot;&quot;)<br>Signed-off-by: Caner =C3=96ZDERE &lt;<a href=3D"m=
ailto:cnrzdr.dev@gmail.com">cnrzdr.dev@gmail.com</a>&gt;<br>---<br>=C2=A0mm=
/bpf_memcontrol.c | 9 ++++++++-<br>=C2=A01 file changed, 8 insertions(+), 1=
 deletion(-)<br><br>diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c<=
br>index 716df49..3e8721b 100644<br>--- a/mm/bpf_memcontrol.c<br>+++ b/mm/b=
pf_memcontrol.c<br>@@ -25,7 +25,14 @@ __bpf_kfunc struct mem_cgroup *bpf_ge=
t_root_mem_cgroup(void)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mem_cgroup_disab=
led())<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NU=
LL;<br>=C2=A0<br>- =C2=A0 =C2=A0 =C2=A0 /* css_get() is not needed */<br>+ =
=C2=A0 =C2=A0 =C2=A0 /*<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* BPF verifier enfo=
rces a match between this KF_ACQUIRE kfunc<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0=
* and bpf_put_mem_cgroup() (KF_RELEASE). Since the release<br>+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* function unconditionally calls css_put(), we must acquir=
e a<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* reference here to balance it.<br>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>+ =C2=A0 =C2=A0 =C2=A0 css_get(&amp;root_m=
em_cgroup-&gt;css);<br>+<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return root_mem_cgr=
oup;<br>=C2=A0}<br>=C2=A0<br>--<br>2.50.1 (Apple Git-155)</div><br><div cla=
ss=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_at=
tr">Greg KH &lt;<a href=3D"mailto:gregkh@linuxfoundation.org">gregkh@linuxf=
oundation.org</a>&gt;, 1 May 2026 Cum, 15:54 tarihinde =C5=9Funu yazd=C4=B1=
:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, May 01=
, 2026 at 03:40:46PM +0300, Caner =C3=96ZDERE wrote:<br>
&gt; Hi Greg,<br>
&gt; <br>
&gt; Thank you for the quick response.<br>
&gt; <br>
&gt; I have since confirmed that the bug is present in v7.0, which was<br>
&gt; released as a stable kernel on 2026-04-12. The affected file can be<br=
>
&gt; verified at:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0<a href=3D"https://github.com/torvalds/linux/blob/v7.0/mm/=
bpf_memcontrol.c" rel=3D"noreferrer" target=3D"_blank">https://github.com/t=
orvalds/linux/blob/v7.0/mm/bpf_memcontrol.c</a><br>
<br>
Ok, then can you turn your patch into something that can be accepted and<br=
>
send it here and cc: the bpf maintainers for their review?<br>
<br>
thanks,<br>
<br>
greg k-h<br>
</blockquote></div></div>

--000000000000b7af800650c1e144--

