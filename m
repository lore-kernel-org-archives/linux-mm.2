Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F75F3380C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0616B0089; Tue, 17 Mar 2026 04:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FC26B008A; Tue, 17 Mar 2026 04:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D851C6B008C; Tue, 17 Mar 2026 04:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C29C06B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:33:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 806B31A05A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:33:37 +0000 (UTC)
X-FDA: 84554891274.15.385E5A0
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88B50C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:33:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UNdSsuft;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of changfengnan@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=changfengnan@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773736416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouY2DlmxHP8dSdFOfc8RggJly7xAXy6YWI/q1/g6vaI=;
	b=h8rkSk8nvoeiCecH6lxmLUPbg3gi96MXFT3k1QCnASKip9KyBVQ83I7T87+o483aRHilv9
	S2o2x5lL9cqwa/Hqr+KOpyC51OwJMx1GJSGItPXnmwnzKLf/puJEC8fJ9b6fPIqm64BSZn
	+rvvOZ+NznJ49Whg3UxkmIpAQADujsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773736416; a=rsa-sha256;
	cv=none;
	b=KM6pfb+7kEujcqOMakSV/KCkctRbEslXk5fpq16Ys60K1iXD8uAzS3/5Iqp8BOeTP01T8Q
	lX33AXyyroXw4QLV4GX8qDWllsiY28kkTJXkIO2Vih2jjtmR3Oxim669YKCT1osdXockU2
	sTZfgpvUicXQCGOZG50xpKk3x6l7Fmk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UNdSsuft;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of changfengnan@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=changfengnan@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773736409; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ouY2DlmxHP8dSdFOfc8RggJly7xAXy6YWI/q1/g6vaI=;
 b=UNdSsuftD9G9ZDe1RiM5S1tQwhHyI8KCu3XHAXVRMcK1kKxpaCne5ibOQUoSEReqUIhzQ5
 Lp1OWbn/Z+Z8nzj6xNDZiqM67IwG4KZCT4DiV9lrD05kkjdhhtmilgxCb1Tq5AeVfGm+H0
 Gaw7fp5Hl+JaqFEQi/EGON2btc2ReFB2mint/9+DLNyo+1XOPxkpG1Zx0Hjm+nrtRN3AqU
 efgVhGd2l+kTqdscuzRWRKO+kACt1NPdWT9/lzeOZMd8khZgZLgxaLHTo+rs/gB1IGUpD3
 K20DbMYJPb2Coe8+FYtS/UZncgvud4L9r9tvqygFx9QuUlh+jRjXC5kras6JUw==
Date: Tue, 17 Mar 2026 16:33:24 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
References: <20260115021108.1913695-1-guzebing1612@gmail.com> <aWh06YoiJrR3-J-X@dread.disaster.area> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com> <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
	<abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
In-Reply-To: <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
X-Lms-Return-Path: <lba+169b911d7+148502+kvack.org+changfengnan@bytedance.com>
Cc: "Dave Chinner" <david@fromorbit.com>, "Harry Yoo" <harry.yoo@oracle.com>, 
	"Hao Li" <hao.li@linux.dev>, "guzebing" <guzebing1612@gmail.com>, 
	<brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, 
	<syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
From: "changfengnan" <changfengnan@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88B50C0005
X-Stat-Signature: dg5qer6poizukr7r7u6p5mju7nybszj8
X-Rspam-User: 
X-HE-Tag: 1773736414-161254
X-HE-Meta: U2FsdGVkX1/nGb7+wzLVkREg/KaYtZQgycMO/P+E1wZGVBhgi2TYnpPwFnQhiF5A6pgMT9BPGCCyAsZ81/TCVGQgD7WTQN5Bgg4Orm0bh+fKnsCOAxq5uk69nuj22pRcT3xbRINPJS++jJhycgiw3arqXqI3lRJBJtUMxdSnDNezlIYvBibSrxHRkgPxge5w0clCTI/03QsWa2vhHA3Qdn+Ipfvkj4OV9oabTw7yMPs3wPwd+YB6GynV4LI/GWscj5Ol54JS+zGiB7JsMSBlUOsckfov3ttwCh93uwNbINKryIyreuUTDq3mL5YFSEuqQU7dFKDH2xT+34QJoYK9adVngsaFqYMI9YMlmwICGR3v/W2RilVF1Anuv/z/I4FY+Ixxc1yyWBHgYNx9jo9Nm1hTHNq67Xpf3e+1znsnVIH2+OaZErroItu8yKwAf4zqbhT348kL+weCBuGHYaM6EVrJErELQmT+qYGzthGGR4b6WoI+DNqvWZRF81V8YfAW5VRiasb55yhIF3TgKHqXyLUkOcCV/lXSTB907MUMpCrIuWE1ACVKocYY7jmXx/eKvGZ2UfEDsjptVfd+nYVfL0QC2OSDTyLmJlfW5pUt3wEJEqHvtAUS4m4olKbjTIYcvVVybdPMhnAxWB6ABmsRBFpnN/R9wpoRx+LSfubJrnAAu4xT0obYC7RRdaFnSdXGJSStHH+KdA+qVv/X9VjmfseT2peUTT2Ew7mp10U3wntNbiotlolvvQmZ7QOx+A7UMn/OMg87cThEa464IBy3XulbByn4qn/y7JMRrhFTFYy6tXRVrsSabom4jst0L6AjVuXdPzZLU/kl6lw+ZdL32GQr4si6SadFkixVgUK1sl5JegGvI/zAdT3XvK8+8Hw9mJjqwSSquxSGXAjY3KFmP3ZwhDC4tCIxbo7jt/tMV9WBOa6cbuiI8gvGKe5SwU9q4FEThJSmDohyKwIlJx6
 8OEJgRE2
 H+zpe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> From: "Vlastimil Babka (SUSE)"<vbabka@kernel.org>
> Date:=C2=A0 Tue, Mar 17, 2026, 16:28
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Dave Chinner"<david@fromorbit.com>, "Harry Yoo"<harry.yoo@oracle.com=
>, "Hao Li"<hao.li@linux.dev>, "guzebing"<guzebing1612@gmail.com>, <brauner=
@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.ker=
nel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, =
<guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>, <linux-mm@kva=
ck.org>
> On 3/17/26 08:28, changfengnan wrote:
> >=C2=A0
> >> That suggests in that test you used larger capacity than the automatic=
ally
> >> calculated.
> > The 10% improvement is due to the every cache has sheaves.
> > When I tested 256-byte objects, default sheaf_capacity is 26, allocatin=
g and
> > freeing 32 objects did not show a noticeable difference, but allocating=
 and
> > freeing 128 objects resulted in a significant improvement, about 3-4x i=
n a=C2=A0
> > multithreaded environment.=C2=A0 about 12% improvement in single thread=
.
>=C2=A0
> Great!
>=C2=A0
> >> =C2=A0
> >> > I'm thinking that maybe these improvements may not be significant en=
ough to
> >> > see the effect in the io flow.
> >> > Using a simple list seems to be the most efficient approach.
> >>=C2=A0
> >> I think the question is, what improvement do you now see with your add=
ed
> >> pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?
> >=C2=A0
> > On 7.0-rc4, pcpu get 1.20M IOPS , kmalloc get 1.19M IOPS, new cache wit=
h set sheaf_capacity 256, 1.19M IOPS
> > On 6.19, pcpu get 1.20M IOPS,=C2=A0 kmalloc get 1.17M IOPS, new cache w=
ith set sheaf_capacity 256, 1.19M IOPS.
>=C2=A0
> Thanks a lot for that data. My conclusion is that kmalloc before sheaves =
did
> indeed worse and custom pcpu cache improved it relatively more. Kmalloc w=
ith
> sheaves does better, and the improvement of custom pcpu cache is smaller.
> Also the default sheaf capacity seems to be enough for this workload.
Agree.
>=C2=A0
> IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
> worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
Yes, at least for now, there=E2=80=99s no need for a per-CPU.
It might be better to replace kmalloc with a new cache, but my tests so far
haven=E2=80=99t shown any performance improvements.=C2=A0 I=E2=80=99ll look=
 into it further.

>=C2=A0

